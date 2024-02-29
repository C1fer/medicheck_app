import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/styles/app_styles.dart';

import '../../../styles/app_colors.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {super.key, required this.title, this.body, this.actions, this.iconPath});

  final String title;
  final String? iconPath;
  final String? body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            alignment: Alignment.center,
            height: 102,
            width: 102,
            decoration: BoxDecoration(
                color: AppColors.blueGray,
                borderRadius: BorderRadius.circular(50.0)),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: SvgPicture.asset(iconPath ?? 'assets/icons/done.svg'),
            )),
        const SizedBox(
          height: 40,
        ),
        Text(
          title,
          style: AppStyles.headingTextStyle.copyWith(fontSize: 20.0),
        ),
        if (body != null)
          Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                body!,
                style: AppStyles.mainTextStyle,
              ),
            ],
          ),
        const SizedBox(
          height: 24,
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions ??
                [
                  FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ]
        ),
      ],
    );
  }
}
