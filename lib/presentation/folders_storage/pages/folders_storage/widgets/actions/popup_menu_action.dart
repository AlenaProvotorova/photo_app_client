import 'package:flutter/material.dart';

class PopupMenuAction {
  final String title;
  final VoidCallback onTap;

  PopupMenuAction({
    required this.title,
    required this.onTap,
  });
}
