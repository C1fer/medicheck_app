import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class DataLoadingIndicator extends StatelessWidget {
  const DataLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Expanded(
        child: Center(
            child: CircularProgressIndicator(
              color: AppColors.jadeGreen,
            )));
  }
}
