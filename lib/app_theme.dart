import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const background = Color(0xFFFFF7FF);
  static const orange = Color(0xFFFF5722);
  static const appBarOrange = Color(0xFFD93600);
  static const splashOrange = Color(0xFFE63200);
  static const resultGreen = Color(0xFFC8E6C9);
  static const resultRed = Color(0xFFF4513D);

  static ThemeData get theme => ThemeData(
    useMaterial3: false,
    fontFamily: 'Kanit',
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(
      primary: orange,
      secondary: orange,
      surface: background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarOrange,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 21,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: orange,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 48),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ),
  );
}
