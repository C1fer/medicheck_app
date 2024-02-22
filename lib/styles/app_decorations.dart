import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  static final stepCounterDecoration = ShapeDecoration(
      color: AppColors.jadeGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(56),
      ));

  static final formTextFieldDecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: TextStyle(color: AppColors.jadeGreen),
    fillColor: AppColors.offWhite,
      hintStyle: TextStyle(color: AppColors.lightGray, fontWeight: FontWeight.normal),
      prefixIconColor: AppColors.lightGray,
      border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: AppColors.deeperGray,
          ),
        borderRadius: BorderRadius.circular(24)
      ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: AppColors.jadeGreen,
        ),
        borderRadius: BorderRadius.circular(24)
    ),
  );
}
