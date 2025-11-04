// lib/src/theme/button_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppButtonStyles {
  // 👇 Base button builder — reusable across all button variants
  static ButtonStyle _base({
    required Color background,
    required Color foreground,
    
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(color: AppColors.white, width: 2),  
      ),
      textStyle: GoogleFonts.dmSerifText(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
      elevation: 4,
    );
  }

  // ✅ Primary button: white background, black text
  static final ButtonStyle primary = _base(
    background: AppColors.white,
    foreground: AppColors.black, 
  );

  // ✅ Secondary button: black background, white text
  static final ButtonStyle secondary = _base(
    background: AppColors.black,
    foreground: AppColors.white, 
  );
}
