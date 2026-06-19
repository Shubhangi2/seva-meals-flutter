import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/datasource/auth_datasource.dart';
import 'package:seva_meal/core/failure.dart';

class UserAuthProvider extends ChangeNotifier {
  final AuthDatasource authDatasource;

  UserAuthProvider({required this.authDatasource});
  Future<Either<Failure, UserCredential>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    return await authDatasource.createUserWithEmailAndPassword(name, email, password);
  }

  Future<Either<Failure, UserCredential>> authenticateUserWithGoogle() async {
    return await authDatasource.authenticateUserWithGoogle();
  }

  Future<Either<Failure, UserCredential>> loginWithemailAndPassword(
    String email,
    String password,
  ) async {
    return await authDatasource.loginWithemailAndPassword(email, password);
  }

  Future<void> signOut() async {
    return await authDatasource.signOut();
  }

  Future<void> updateRoleToFirebase(String role, String uid) async {
    return await authDatasource.updateRoleToFirebase(role, uid);
  }
}
