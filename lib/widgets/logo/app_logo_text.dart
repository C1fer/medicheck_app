import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../styles/app_colors.dart';

class AppLogoText extends StatelessWidget {
  AppLogoText({super.key, this.color, required this.fontSize});
  final double fontSize;
  Color? color = AppColors.jadeGreen;

  @override
  Widget build(BuildContext context) {
    return Text(
      "MediCheck",
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
