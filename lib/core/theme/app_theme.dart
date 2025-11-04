// lib/src/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,

    textTheme: GoogleFonts.dmSerifTextTextTheme().apply(
      bodyColor: AppColors.offWhite,  
      displayColor: AppColors.offWhite,
    ), 
  );
}
