import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';

class AuthDatasource {
  final SharedPrefs sharedPrefs = SharedPrefs();

  Future<void> saveUserInPrefs({required UserCredential credentials, String? fullName}) async {
    print(credentials.user?.uid);
    UserModel user = UserModel(
      id: credentials.user?.uid ?? '',
      role: '',
      fullName: fullName ?? credentials.user?.displayName ?? '',
      mobileNo: '',
      email: credentials.user?.email ?? '',
      city: '',
    );
    await uploadUserToFirebase(user);
    await sharedPrefs.saveUserModel(user);
  }

  Future<void> uploadUserToFirebase(UserModel user) async {
    final db = FirebaseFirestore.instance;
    try {
      final doc = await db.collection("users").add(user.toJson());
      print(doc.id);
    } catch (e) {
      print(e);
    }
  }

  Future<Either<Failure, UserCredential>> createUserWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user?.uid == null) return left(Failure("User id is null"));
      await saveUserInPrefs(credentials: credential, fullName: fullName);
      await credential.user!.updateDisplayName(fullName);
      return right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure("The account already exists for that email."));
      }
    } catch (e) {
      print(e);
    }

    return left(Failure("Failed to create user"));
  }

  Future<Either<Failure, UserCredential>> authenticateUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) return left(Failure("Google user is null"));

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await saveUserInPrefs(credentials: userCredential);
      return right(userCredential);
    } catch (e) {
      print(e);
    }
    return left(Failure("Failed to login"));
  }

  Future<Either<Failure, UserCredential>> loginWithemailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserInPrefs(credentials: credential);
      return right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(Failure("No user found for that email."));
      } else if (e.code == 'wrong-password') {
        return left(Failure("Wrong password provided for that user."));
      }
    } catch (e) {
      print(e);
    }
    return left(Failure("Failed to login"));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await sharedPrefs.clearPrefs();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRoleToFirebase(String role, String uid) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection("users").doc(uid).update({"role": role});
    } catch (e) {
      print(e);
    }
  }
}
