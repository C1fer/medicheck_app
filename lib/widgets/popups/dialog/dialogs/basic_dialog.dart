import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/styles/app_styles.dart';

import '../../../../styles/app_colors.dart';

class BasicDialog extends StatelessWidget {
  const BasicDialog(
      {super.key,
      required this.title,
      this.body,
      this.actions,
      required this.icon,
      this.iconColor = AppColors.jadeGreen
      });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? body;
  final List<Widget>? actions;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         DialogIcon(),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: AppStyles.headingTextStyle.copyWith(fontSize: 20.0),
          ),
          if (body != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                body!,
                textAlign: TextAlign.center,
                style: AppStyles.mainTextStyle,
              ),
            ),
          const SizedBox(
            height: 30,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: actions ??
                  [
                    FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'))
                  ]),
        ],
      ),
    );
  }

  Widget DialogIcon(){
    return  Container(
        alignment: Alignment.center,
        height: 102,
        width: 102,
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(50.0)),
        child: Icon(icon, size: 52, color: iconColor, )
    );
  }
}
