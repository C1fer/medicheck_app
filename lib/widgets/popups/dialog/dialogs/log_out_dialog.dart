import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../screens/welcome/welcome.dart';
import '../../../../utils/jwt_service.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BasicDialog(
      title: locale.log_out_confirmation,
      iconPath: 'assets/icons/logout.svg',
      actions: [
        FilledButton(
            onPressed: () async {
              JWTService.deleteJWT();
              Navigator.pushReplacementNamed(context, Welcome.id);
            },
            child: Text(locale.log_out)),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text(
                locale.cancel,
                style: AppStyles.actionTextStyle.copyWith(fontWeight: FontWeight.w600),
              ),
            ))
      ],
    );
  }
}
