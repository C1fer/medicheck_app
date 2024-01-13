import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: ShapeDecoration(
        color: AppColors.lightJade,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Text(
        msg,
        style: AppStyles.featureCardTextStyle,
      ),
    );
  }
}
