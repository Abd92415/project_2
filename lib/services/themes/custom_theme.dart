import 'app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static String? fontFamilyApp = GoogleFonts.sansita().fontFamily;
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      // scaffoldBackgroundColor: AppColors.prColorblue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 20,
        // color: AppColors.prColorblue,
        color: Colors.blue,
        foregroundColor: AppColors.bgwhite,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.bgWhite),
        titleTextStyle: TextStyle(
          color: AppColors.bgwhite,
          letterSpacing: 2,
          fontSize: 25,
          fontFamily: fontFamilyApp,
        ),
      ),
      hintColor: AppColors.blueAccent1,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.bgBlue,
            displayColor: AppColors.textColor200,
            fontFamily: fontFamilyApp,
          ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkBg3,
        appBarTheme: AppBarTheme(
          elevation: 10,
          color: AppColors.darkBg100,
          foregroundColor: AppColors.darkTextColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.darkAccent1),
          titleTextStyle: TextStyle(
            color: AppColors.darkTextColor,
            fontSize: 20,
            letterSpacing: 2,
            fontFamily: fontFamilyApp,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.darkTextColor,
              displayColor: AppColors.darkTextColor,
              fontFamily: fontFamilyApp,
            ),
        inputDecorationTheme: InputDecorationTheme(
            iconColor: AppColors.darkAccent1,
            suffixIconColor: AppColors.darkAccent2),
        hintColor: AppColors.blueAccent1,
        dividerTheme: DividerThemeData(color: AppColors.darkTextColor));
  }
}
