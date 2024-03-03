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
    labelStyle: const TextStyle(color: AppColors.lightGray),
    fillColor: AppColors.whiteGray,
      hintStyle: const TextStyle(color: AppColors.lightGray, fontWeight: FontWeight.normal),
      prefixIconColor: AppColors.lightGray,
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.deeperGray,
            strokeAlign: 1
          ),
        borderRadius: BorderRadius.circular(24)
      ),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.jadeGreen,
        ),
        borderRadius: BorderRadius.circular(24)
    ),
  );


static final dropdownButtonFieldDecoration = InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: const TextStyle(color: AppColors.jadeGreen),
    fillColor: AppColors.whiteGray,
      hintStyle: const TextStyle(color: AppColors.lightGray, fontWeight: FontWeight.normal),
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.deeperGray,
            strokeAlign: 1
          ),
        borderRadius: BorderRadius.circular(24)
      ),
  );

}