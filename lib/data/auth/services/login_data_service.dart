import 'package:hive/hive.dart';
import 'package:photo_app/data/auth/models/login_data.dart';

class LoginDataService {
  static const String _boxName = 'login_data';
  static const String _key = 'saved_login';

  static Future<void> init() async {
    await Hive.openBox<LoginData>(_boxName);
  }

  static Future<void> saveLoginData({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final box = Hive.box<LoginData>(_boxName);

      if (rememberMe) {
        final loginData = LoginData(
          email: email,
          password: password,
          rememberMe: rememberMe,
        );
        await box.put(_key, loginData);
      } else {
        await box.delete(_key);
      }
    } catch (e) {}
  }

  static LoginData? getSavedLoginData() {
    try {
      final box = Hive.box<LoginData>(_boxName);
      final data = box.get(_key);
      return data;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearSavedLoginData() async {
    final box = Hive.box<LoginData>(_boxName);
    await box.delete(_key);
  }

  static bool hasSavedLoginData() {
    final box = Hive.box<LoginData>(_boxName);
    return box.containsKey(_key);
  }
}
