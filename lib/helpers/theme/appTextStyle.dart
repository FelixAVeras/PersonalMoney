import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = GoogleFonts.montserratTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textBlack,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textBlack,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
      ),
    ),
  );

  static TextTheme darkTextTheme = GoogleFonts.montserratTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textWhite,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textWhite,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
    ),
  );
}