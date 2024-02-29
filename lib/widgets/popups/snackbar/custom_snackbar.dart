import 'package:flutter/material.dart';
import '../../../models/enums.dart';
import '../../../styles/app_colors.dart';

class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar({super.key, required this.messageType, required this.message});

  final MessageType messageType;
  final String message;

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

  @override
  Widget build(BuildContext context) {
   final bgColor = setBgColor(messageType);
    return SnackBar(
        backgroundColor: bgColor,
        content: Text(message)
    );
  }
}

