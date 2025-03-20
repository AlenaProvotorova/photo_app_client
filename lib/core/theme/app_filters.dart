import 'package:flutter/material.dart';

class AppFilters {
  static const gray = ColorFilter.matrix([
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  static const transparent = ColorFilter.mode(
    Colors.transparent,
    BlendMode.srcOver,
  );
}
