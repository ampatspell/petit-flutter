import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color grey249 = Color.fromARGB(255, 249, 249, 249);
  static const Color grey245 = Color.fromARGB(255, 245, 245, 245);
  static const Color grey230 = Color.fromARGB(255, 230, 230, 230);
  static const Color grey200 = Color.fromARGB(255, 200, 200, 200);
  static const Color grey150 = Color.fromARGB(255, 150, 150, 150);
  static const Color grey020 = Color.fromARGB(255, 20, 20, 20);
  static const Color grey000 = Color.fromARGB(255, 0, 0, 0);
}

abstract class AppTextStyle {
  static final TextStyle regular = GoogleFonts.ubuntuMono(fontSize: 15);
  static final TextStyle regularBold = GoogleFonts.ubuntuMono(fontSize: 15, fontWeight: FontWeight.bold);
}

abstract class AppEdgeInsets {
  static const EdgeInsets symmetric15x7 = EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0);
  static const EdgeInsets all10 = EdgeInsets.all(10);
}

abstract class AppGaps {
  static const Gap gap10 = Gap(10);
}

final appTheme = ThemeData(
  useMaterial3: true,
  hoverColor: AppColors.grey249,
  splashColor: AppColors.grey245,
  textTheme: TextTheme(
    bodyMedium: AppTextStyle.regular, // Text() default
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      foregroundColor: AppColors.grey020,
      backgroundColor: AppColors.grey245,
      textStyle: AppTextStyle.regular,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      elevation: 1,
    ),
  ),
);
