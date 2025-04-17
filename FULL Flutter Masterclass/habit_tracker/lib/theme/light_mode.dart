import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.blue.shade300,
    primary: Colors.blue.shade500,
    secondary: Colors.blue.shade100,
    tertiary: Colors.white,
    inversePrimary: Colors.blue.shade900
  ),
);
