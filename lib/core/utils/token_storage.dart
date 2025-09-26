import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TokenStorage {
  static const String _tokenBox = 'tokenBox';
  static const String _tokenKey = 'userToken';

  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_tokenBox)) {
        await Hive.openBox(_tokenBox);
      }
    } catch (e) {
      debugPrint("Error initializing token storage: $e");
      // Try to delete and recreate the box if there's a lock issue
      try {
        await Hive.deleteBoxFromDisk(_tokenBox);
        await Hive.openBox(_tokenBox);
      } catch (e2) {
        debugPrint("Error recreating token storage: $e2");
      }
    }
  }

  static Future<void> saveToken(String token) async {
    var box = Hive.box(_tokenBox);
    await box.put(_tokenKey, token);
  }

  static Future<String?> loadToken() async {
    try {
      var box = Hive.box(_tokenBox);
      return box.get(_tokenKey);
    } catch (e) {
      debugPrint("Error loading token: $e");
      return null;
    }
  }

  static Future<void> deleteToken() async {
    var box = Hive.box(_tokenBox);
    await box.delete(_tokenKey);
  }
}
