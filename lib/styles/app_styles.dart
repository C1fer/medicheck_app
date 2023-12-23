import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const headingTextStyle = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: AppColors.deepBlue,
  );

  static const sectionTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.deepBlue,
  );

  static const mainTextStyle = TextStyle(
      fontSize: 16.0,
      color: AppColors.lightGray,
  );

  static const subTextStyle = TextStyle(
      fontSize: 16.0,
      color: AppColors.darkGray,
  );

  static const actionTextStyle = TextStyle(
    fontSize: 15.0,
    color: AppColors.jadeGreen,
  );

  static const primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll<Color>(AppColors.jadeGreen),
    textStyle: MaterialStatePropertyAll<TextStyle>(
        TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white
        )
    ),
  );

  static const outlinedButtonStyle = ButtonStyle(
    foregroundColor: MaterialStatePropertyAll<Color>(AppColors.jadeGreen),
    textStyle: MaterialStatePropertyAll<TextStyle>(
        TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.jadeGreen
        )
    ),
    side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: AppColors.jadeGreen ))
  );


  static const TextButtonStyle = ButtonStyle(
    textStyle: MaterialStatePropertyAll<TextStyle>(
        TextStyle(
          fontSize: 15.0,
          color: AppColors.jadeGreen,)
    )
  );

}
