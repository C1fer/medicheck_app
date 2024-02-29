import 'package:flutter/material.dart';
import '../../../models/enums.dart';
import '../../../styles/app_colors.dart';

Color setBgColor(MessageType type){
  switch(type){
    case MessageType.WARNING || MessageType.INFO:
      return const Color(0xFF323232);
    case MessageType.ERROR:
      return Colors.red;
    case MessageType.SUCCESS:
      return AppColors.jadeGreen;
  }
}

void showSnackBar(BuildContext context, String message, MessageType messageType) {
  final bgColor = setBgColor(messageType);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: bgColor,
      content: Text(message)
    ),
  );
}

