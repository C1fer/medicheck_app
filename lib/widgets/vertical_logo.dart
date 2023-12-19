import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerticalLogo extends StatelessWidget {
  final Color color;
  const VerticalLogo({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset('assets/logo/logo.svg', color: color),
        ),
        Text(
          "MediCheck",
          style: TextStyle(
            color: color,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}
