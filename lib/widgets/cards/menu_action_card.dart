import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class MenuActionCard extends StatelessWidget {
  MenuActionCard(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.route});

  String title;
  String iconPath;
  String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width:64,
              height: 56,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 70,
                    offset: Offset(0, 17),
                    spreadRadius: -11,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: SvgPicture.asset(
                  iconPath,
                  color: AppColors.jadeGreen,
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(title, style: AppStyles.subMediumTextStyle),
          ),
        ],
      ),
    );
  }
}
