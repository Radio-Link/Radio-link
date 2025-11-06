import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // 🧭 Input field labels
  static final label = GoogleFonts.dmSerifText(
    color: AppColors.whiteGray,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  // ✏️ Text inside TextFields
  static final input = GoogleFonts.dmSerifText(
    color: AppColors.offWhite,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  // 🏷️ Screen title
  static final heading = GoogleFonts.dmSerifText(
    color: AppColors.offWhite,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  // 🔁 Small text under buttons
  static final toggleBase = GoogleFonts.dmSerifText(
    color: AppColors.whiteGray,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  // ❤️ Red emphasized text (like “Register” or “Login”)
  static final toggleHighlight = GoogleFonts.dmSerifText(
    color: AppColors.red,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
