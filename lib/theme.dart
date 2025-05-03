import 'package:flutter/material.dart';

var theme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.teal, // Primary color
    secondary: Colors.amber[600]!, // Accent color
    surface: Colors.white, // Background color
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.teal[50],
    // Very light teal background
    contentPadding: EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, // No border when not focused
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.teal[100]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.teal, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red[400]!),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    labelStyle: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.w500),
    hintStyle: TextStyle(color: Colors.teal[200]),
    errorStyle: TextStyle(color: Colors.red[600]),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.teal[800],
    selectionColor: Colors.teal[100],
    selectionHandleColor: Colors.teal,
  ),
);
