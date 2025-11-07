import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FolderDialogStorage {
  static const String _dialogBox = 'folderDialogBox';
  static const String _prefix = 'firstVisit_';

  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_dialogBox)) {
        await Hive.openBox(_dialogBox);
      }
    } catch (e) {
      debugPrint("Error initializing folder dialog storage: $e");
      try {
        await Hive.deleteBoxFromDisk(_dialogBox);
        await Hive.openBox(_dialogBox);
      } catch (e2) {
        debugPrint("Error recreating folder dialog storage: $e2");
      }
    }
  }

  static Future<void> markDialogShown(String folderId) async {
    try {
      var box = Hive.box(_dialogBox);
      await box.put('$_prefix$folderId', true);
    } catch (e) {
      debugPrint("Error marking dialog as shown: $e");
    }
  }

  static bool hasDialogBeenShown(String folderId) {
    try {
      var box = Hive.box(_dialogBox);
      return box.get('$_prefix$folderId', defaultValue: false) as bool;
    } catch (e) {
      debugPrint("Error checking if dialog was shown: $e");
      return false;
    }
  }
}

