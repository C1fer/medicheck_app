import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/widgets/logo/app_logo_text.dart';
import 'app_logo_icon.dart';

enum LogoOrientation { Horizontal, Vertical }

class AppLogo extends StatelessWidget {
  final Color color;
  final double fontSize;
  final double width;
  final double height;
  final LogoOrientation orientation;

  const AppLogo(
      {super.key,
      required this.color,
      required this.fontSize,
      required this.width,
      required this.height,
      required this.orientation});

  @override
  Widget build(BuildContext context) {
    return orientation == LogoOrientation.Vertical
        ? VerticalLogo()
        : HorizontalLogo();
  }

  Column VerticalLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLogoIcon(color: color, width: width, height: height),
        const SizedBox(
          height: 4.0,
        ),
        AppLogoText(fontSize: fontSize, color: color,),
      ],
    );
  }

  Row HorizontalLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLogoIcon(color: color, width: width, height: height),
        const SizedBox(
          width: 6.0,
        ),
        AppLogoText(fontSize: fontSize, color: color),
      ],
    );
  }
}
