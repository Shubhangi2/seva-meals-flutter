import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seva_meal/core/failure.dart';

class AuthDatasource {
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
}
