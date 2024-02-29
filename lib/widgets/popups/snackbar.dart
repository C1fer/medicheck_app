import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, {Color? bgColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor ?? Colors.red,
      content: Text(message)
    ),
  );
}