import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_styles.dart';

import '../../styles/app_colors.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.msg, this.color = AppColors.jadeGreen});

  final String msg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: ShapeDecoration(
        color: color.withOpacity(0.11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.23),
        ),
      ),
      child: Text(
        msg,
        style: AppStyles.featureCardTextStyle.copyWith(color: color),
      ),
    );
  }
}
