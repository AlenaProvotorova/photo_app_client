import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: Colors.blue, // Основной цвет
      secondary: Colors.amberAccent, // Вторичный цвет
      surface: Colors.white, // Цвет поверхности
      error: Colors.red, // Цвет ошибки
      onPrimary: Colors.green, // Цвет текста на основном цвете
      onSecondary: Colors.green, // Цвет текста на вторичном цвете
      onSurface: Colors.black, // Цвет текста на поверхности
      onError: Colors.green, // Цвет текста на ошибке
      brightness: Brightness.light, //
    ),
    useMaterial3: false,
    dividerColor: Colors.white60,
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
            color: Colors.red, fontSize: 20, fontWeight: FontWeight.w700)),
    listTileTheme: const ListTileThemeData(iconColor: Colors.white60),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ),
      headlineSmall: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
          color: Colors.black, fontSize: 12, fontWeight: FontWeight.w700),
      bodySmall: TextStyle(color: Colors.blueGrey, fontSize: 12),
    ));
