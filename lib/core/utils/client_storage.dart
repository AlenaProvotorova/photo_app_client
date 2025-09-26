import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClientStorage {
  static const String _clientBox = 'clientBox';
  static const String _clientKey = 'client';

  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_clientBox)) {
        await Hive.openBox(_clientBox);
      }
    } catch (e) {
      debugPrint("Error initializing client storage: $e");
      // Try to delete and recreate the box if there's a lock issue
      try {
        await Hive.deleteBoxFromDisk(_clientBox);
        await Hive.openBox(_clientBox);
      } catch (e2) {
        debugPrint("Error recreating client storage: $e2");
      }
    }
  }

  static Future<void> saveClient(String client) async {
    var box = Hive.box(_clientBox);
    await box.put(_clientKey, client);
  }

  static Future<String?> loadClient() async {
    try {
      var box = Hive.box(_clientBox);
      return box.get(_clientKey);
    } catch (e) {
      debugPrint("Error loading client: $e");
      return null;
    }
  }

  static Future<void> deleteClient() async {
    var box = Hive.box(_clientBox);
    await box.delete(_clientKey);
  }
}
