import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';

import '../../../../../styles/app_colors.dart';

class LocationDeniedDialog extends StatelessWidget {
  const LocationDeniedDialog({super.key});

  Future<void> onActionPressed(BuildContext context) async {
    await Geolocator.openAppSettings();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BasicDialog(
      title: locale.permission_required,
      icon: Icons.wrong_location_outlined,
      iconColor: AppColors.lightRed,
      body: locale.location_permissions_denied,
      actions: [
        FilledButton(
            onPressed: () => onActionPressed(context),
            child: Text(locale.goto_app_settings)),
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
