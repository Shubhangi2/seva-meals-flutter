import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seva_meal/core/utils/user_session.dart';
import 'package:seva_meal/datasource/auth_datasource.dart';
import 'package:seva_meal/core/failure.dart';
import 'package:seva_meal/models/user_model.dart';

class UserAuthProvider extends ChangeNotifier {
  final AuthDatasource authDatasource;

  UserAuthProvider({required this.authDatasource});

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<Either<Failure, UserModel>> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    return await authDatasource.createUserWithEmailAndPassword(name, email, password);
  }

  Future<Either<Failure, UserModel>> authenticateUserWithGoogle() async {
    return await authDatasource.authenticateUserWithGoogle();
  }

  Future<Either<Failure, UserModel>> loginWithemailAndPassword(
    String email,
    String password,
  ) async {
    return await authDatasource.loginWithemailAndPassword(email, password);
  }

  Future<void> signOut() async {
    return await authDatasource.signOut();
  }

  Future<void> saveUserDetails(UserModel user) async {
    return await authDatasource.saveUserDetails(user);
  }

  Future<Either<Failure, UserModel>> editUser(UserModel updatedUser) async {
    return await authDatasource.editUser(updatedUser);
  }
}
