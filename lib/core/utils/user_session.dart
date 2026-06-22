import 'package:seva_meal/core/constants.dart';
import 'package:seva_meal/db/shared_prefs.dart';
import 'package:seva_meal/models/user_model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUser() async {
    _user = await SharedPrefs().getUserModel();
  }

  void setUser(UserModel user) {
    _user = user;
  }

  void clearUser() {
    _user = null;
    SharedPrefs().clearKey(Constants.USER_MODEL);
  }
}
