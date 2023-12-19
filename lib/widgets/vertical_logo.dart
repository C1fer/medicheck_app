import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerticalLogo extends StatelessWidget {
  final Color color;
  final double fontSize;
  final double width;
  final double height;

  const VerticalLogo({super.key, required this.color, required this.fontSize, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/logo/logo.svg', color: color),
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
