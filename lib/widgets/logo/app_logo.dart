import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../generated/assets.dart';
import '../../styles/app_colors.dart';

class AppLogo extends StatelessWidget {
  AppLogo({super.key, required this.width, required this.height, this.color});
  final double width;
  final double height;
  Color? color = AppColors.jadeGreen;

  @override
  Widget build(BuildContext context) {
    return Center(child: SvgPicture.asset(Assets.logoLogo, color: color, width: width, height: height));
  }
}
