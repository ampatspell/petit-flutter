import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color grey200 = Color.fromARGB(255, 200, 200, 200);
  static const Color grey150 = Color.fromARGB(255, 150, 150, 150);
}

abstract class AppTextStyle {
  static final TextStyle regular = GoogleFonts.ubuntuMono(fontSize: 15);
}

final appTheme = ThemeData(
  textTheme: TextTheme(
    bodyMedium: AppTextStyle.regular, // Text() default
  ),
);
