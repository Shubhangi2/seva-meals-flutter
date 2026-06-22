import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';

class AuthDatasource {
  final SharedPrefs sharedPrefs = SharedPrefs();

  Future<UserModel> saveUserInPrefs({required UserCredential credentials, String? fullName}) async {
    print(credentials.user?.uid);
    String fcmToken = await SharedPrefs().getFcmToken();
    UserModel user = UserModel(
      id: credentials.user?.uid ?? '',
      role: '',
      fullName: fullName ?? credentials.user?.displayName ?? '',
      mobileNo: '',
      email: credentials.user?.email ?? '',
      city: '',
      fcmToken: fcmToken,
    );
    await sharedPrefs.saveUserModel(user);
    return user;
  }

  Future<void> saveUserDetails(UserModel user) async {
    final db = FirebaseFirestore.instance;
    try {
      await db.collection("users").doc(user.id).set(user.toJson());
      await SharedPrefs().saveUserModel(user);
    } catch (e) {
      print(e);
    }
  }

  Future<Either<Failure, UserModel>> createUserWithEmailAndPassword(
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
      UserModel user = await saveUserInPrefs(credentials: credential, fullName: fullName);
      await credential.user!.updateDisplayName(fullName);
      return right(user);
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

  Future<Either<Failure, UserModel>> authenticateUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) return left(Failure("Google user is null"));

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      UserModel? userModel;
      if (!isNewUser) {
        userModel = await getUserDataFromFirebase();
      } else {
        userModel = await saveUserInPrefs(credentials: userCredential);
      }
      print(userModel);
      return right(userModel!);
    } catch (e) {
      print(e);
    }
    return left(Failure("Failed to login"));
  }

  Future<UserModel?> getUserDataFromFirebase() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      final db = FirebaseFirestore.instance;
      if (currentUser == null) return null;
      final doc = await db.collection("users").doc(currentUser.uid).get();
      print(doc.data());
      UserModel userModel = UserModel.fromJson(doc.data()!);
      await SharedPrefs().saveUserModel(userModel);
      return userModel;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Either<Failure, UserModel>> loginWithemailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = await saveUserInPrefs(credentials: credential);
      return right(user);
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
      UserModel? user = await sharedPrefs.getUserModel();
      print(user);
    } catch (e) {
      print(e);
    }
  }
}
