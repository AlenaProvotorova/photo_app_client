import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: Color.fromARGB(255, 22, 76, 254), // Основной цвет
      primaryContainer: Color.fromARGB(75, 22, 76, 254), // Основной цвет
      secondary: Color.fromARGB(255, 250, 204, 17), // Вторичный цвет
      surface: Colors.white, // Цвет поверхности
      error: Color.fromARGB(255, 221, 10, 59), // Цвет ошибки
      onPrimary:
          Color.fromARGB(255, 15, 134, 57), // Цвет текста на основном цвете
      onSecondary:
          Color.fromARGB(255, 9, 169, 65), // Цвет текста на вторичном цвете
      onSurface: Color.fromARGB(255, 22, 2, 83), // Цвет текста на поверхности
      onError: Colors.green, // Цвет текста на ошибке
      brightness: Brightness.light, //
    ),
    useMaterial3: false,
    dividerTheme: const DividerThemeData(
      thickness: 1,
      color: Color.fromARGB(255, 205, 205, 205),
    ),
    appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 221, 10, 59),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        )),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white60,
    ),
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
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(color: Colors.blueGrey, fontSize: 12),
    ));
