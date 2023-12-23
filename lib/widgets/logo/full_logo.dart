import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_logo.dart';

class FullLogo extends StatelessWidget {
  final Color color;
  final double fontSize;
  final double width;
  final double height;

  const FullLogo({super.key, required this.color, required this.fontSize, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLogo(color: color, width: width, height: height),
        const SizedBox(height: 4.0,),
        Text(
          "MediCheck",
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}
