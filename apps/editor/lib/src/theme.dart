import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color grey249 = Color.fromARGB(255, 249, 249, 249);
  static const Color grey245 = Color.fromARGB(255, 245, 245, 245);
  static const Color grey230 = Color.fromARGB(255, 230, 230, 230);
  static const Color grey200 = Color.fromARGB(255, 200, 200, 200);
  static const Color grey150 = Color.fromARGB(255, 150, 150, 150);
}

abstract class AppTextStyle {
  static final TextStyle regular = GoogleFonts.ubuntuMono(fontSize: 15);
  static final TextStyle regularBold = GoogleFonts.ubuntuMono(fontSize: 15, fontWeight: FontWeight.bold);
}

abstract class AppEdgeInsets {
  static const EdgeInsets symmetric15x10 = EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0);
}

final appTheme = ThemeData(
  useMaterial3: true,
  hoverColor: AppColors.grey249,
  splashColor: AppColors.grey245,
  textTheme: TextTheme(
    bodyMedium: AppTextStyle.regular, // Text() default
  ),
);
