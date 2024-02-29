import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/styles/app_styles.dart';

Future<void> showAlertDialog(BuildContext context, String title, {String? body, String? buttonMsg}) async {
  await showDialog<void>(
      context: (context),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(24.0),
          backgroundColor: Colors.white,
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: const EdgeInsets.all(32),
            content: Column(
              children: [
                SvgPicture.asset('assets/icons/success.svg'),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  title,
                  style: AppStyles.headingTextStyle.copyWith(fontSize: 20.0),
                ),
                if (body != null)
                  const SizedBox(
                    height: 8,
                  ),
                Text(
                  body!,
                  style: AppStyles.mainTextStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
            actions: [
              FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(buttonMsg ?? 'OK') )
            ]
        );
      }
      );
}
