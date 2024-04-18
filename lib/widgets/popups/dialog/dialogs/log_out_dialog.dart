import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/notifiers/recent_query_notifier.dart';
import 'package:medicheck/models/notifiers/saved_products_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../screens/welcome/welcome.dart';
import '../../../../utils/jwt_service.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BasicDialog(
      title: locale.log_out_confirmation,
      icon: Icons.logout_rounded,
      actions: [
        FilledButton(
            onPressed: () async {
              JWTService.deleteJWT();
              context.read<UserInfoModel>().clear();
              context.read<SavedProductModel>().clear();
              context.read<ViewedCoverageModel>().clear();
              context.read<PlanModel>().clear;
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
