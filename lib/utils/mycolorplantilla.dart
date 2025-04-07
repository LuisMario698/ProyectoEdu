import 'package:flutter/material.dart';

class MyColorThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6200EE), // Deep Purple 500
    hintColor: Colors.grey,
    scaffoldBackgroundColor: Color(0xFFE3F2FD), // Azul claro más visible
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6200EE),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => const Color(0xFF6200EE)),
    ),
    listTileTheme: const ListTileThemeData(textColor: Colors.black),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black87),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6200EE),
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF212121), // Grey 900
    hintColor: Colors.grey[400], // Más claro
    scaffoldBackgroundColor: const Color(0xFF303030), // Grey 800
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF212121),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Texto blanco
      bodyMedium: TextStyle(color: Colors.white70), // Texto blanco
      titleMedium: TextStyle(color: Colors.white70), // Subtítulos blancos
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) => Colors.white70), // Radio buttons blancos
    ),
    listTileTheme: const ListTileThemeData(textColor: Colors.white70), // Texto blanco en ListTile
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.white70), // Labels blancos
      hintStyle: TextStyle(color: Colors.grey[400]), // Hints más claros
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Bordes grises
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70), // Bordes blancos al enfocar
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF212121),
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white70), // Iconos blancos
  );

  static ThemeData vibrantTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF7C4DFF), // Purple 400
    hintColor: Colors.orangeAccent,
    scaffoldBackgroundColor: Color(0xFFE1BEE7), // Más saturado
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF311B92)), // Color más fuerte
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) => const Color(0xFF7C4DFF)),
    ),
    listTileTheme: const ListTileThemeData(textColor: Color(0xFF4A148C)),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF7C4DFF)),
      hintStyle: TextStyle(color: Colors.orangeAccent),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData modernTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF00BCD4), // Teal 500
    hintColor: Colors.blueGrey,
    scaffoldBackgroundColor: Color(0xFFE0F7FA), // Azul claro
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF00BCD4),
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF004D40)), // Teal más oscuro
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) => const Color(0xFF00BCD4)),
    ),
    listTileTheme: const ListTileThemeData(textColor: Color(0xFF263238)),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFF00BCD4)),
      hintStyle: TextStyle(color: Colors.blueGrey),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00BCD4),
      foregroundColor: Colors.white,
    ),
  );
}
