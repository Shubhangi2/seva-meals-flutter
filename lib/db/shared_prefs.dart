import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/core/utils/user_session.dart';
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
    UserSession().setUser(userModel);
    print(userModel.toJson());
    await setString(Constants.USER_MODEL, jsonEncode(userModel.toJson()));
  }

  Future<void> clearKey(String key) async {
    await remove(key);
  }

  Future<String> getFcmToken() async {
    String token = await getString(Constants.FCM_TOKEN);
    if (token.isNotEmpty) {
      return token;
    }
    final fbToken = await FirebaseMessaging.instance.getToken();
    print('Device FCM Token: $fbToken');
    SharedPrefs().saveFCMToken(fbToken ?? '');
    return fbToken ?? '';
  }

  Future<void> saveFCMToken(String token) async {
    await setString(Constants.FCM_TOKEN, token);
  }
}
