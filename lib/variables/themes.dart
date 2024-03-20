import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData mainTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.lightBlue,
    brightness: Brightness.dark,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.openSans(
      fontSize: 64,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 32,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 16,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 12,
    ),
  ),
);
