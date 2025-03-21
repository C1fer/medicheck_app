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

  static const subMediumTextStyle = TextStyle(
      fontSize: 16.0,
      color: AppColors.darkGray,
  );

  static const subSmallTextStyle = TextStyle(
    fontSize: 12.0,
    color: AppColors.darkGray,
  );

  static const actionTextStyle = TextStyle(
    fontSize: 15.0,
    color: AppColors.jadeGreen,
  );

  static const coverageCardHeadingTextStyle = TextStyle(
    color: AppColors.darkerGray,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const coverageCardCategoryTextStyle = TextStyle(
    color: AppColors.deepLightGray,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

static const featureCardTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500
  );

  static const settingTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.deepBlue,
  );

  static const minimumButtonSize = MaterialStatePropertyAll<Size>(Size(10,55));


  static const primaryButtonStyle = ButtonStyle(
    minimumSize: minimumButtonSize,
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
    minimumSize: minimumButtonSize,
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
    minimumSize: minimumButtonSize,
    textStyle: MaterialStatePropertyAll<TextStyle>(
        TextStyle(
          fontSize: 15.0,
          color: AppColors.jadeGreen,)
    )
  );

}
