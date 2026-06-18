import 'dart:convert';

import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/db/base_prefs.dart';
import 'package:seva_meal/models/user_model.dart';

class SharedPrefs extends BasePrefs {
  Future<UserModel?> getUserModel() async {
    String userModelStr = await getString(Constants.USER_MODEL);
    if (userModelStr.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(userModelStr));
    }
    return null;
  }

  Future<void> saveUserModel(UserModel userModel) async {
    await setString(Constants.USER_MODEL, jsonEncode(userModel.toJson()));
  }

  Future<void> updateRole(String role) async {
    UserModel? user = await getUserModel();
    if (user == null) return;
    user.role = role;
    await saveUserModel(user);
  }
}
