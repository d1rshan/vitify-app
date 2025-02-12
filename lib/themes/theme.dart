import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(
        // 18 no bold
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
  ),
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    primary: Colors.black,
    secondary: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    titleLarge: TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
  ),
  colorScheme: const ColorScheme.dark(
    surface: Colors.black, //rgb(26, 27, 38)
    primary: Colors.white,
    secondary: Colors.black,
  ),
);
