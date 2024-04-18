import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import '../../../../../styles/app_colors.dart';

class RequestEnableLocationDialog extends StatelessWidget {
  const RequestEnableLocationDialog({super.key});

  Future<void> onActionPressed(BuildContext context) async {
    await Geolocator.openLocationSettings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BasicDialog(
      title: locale.location_disabled,
      icon: Icons.location_off_outlined,
      iconColor: AppColors.lightRed,
      body: locale.location_permissions_required,
      actions: [
        FilledButton(
            onPressed: () => onActionPressed(context),
            child: Text(locale.enable_location_service)),
        const SizedBox(
          height: 15,
        ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text(
                locale.cancel,
                style: AppStyles.actionTextStyle
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ))
      ],
    );
  }

}
