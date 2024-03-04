import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: ShapeDecoration(
        color: AppColors.lightJade,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.23),
        ),
      ),
      child: Text(
        msg,
        style: AppStyles.featureCardTextStyle,
      ),
    );
  }
}
