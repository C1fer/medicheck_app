import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicheck/screens/home/establishments/nearby_centers.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';

import '../../../bottom_sheet/show_bottom_sheet.dart';
import 'location_denied_dialog.dart';


class RequestLocationPermissionsDialog extends StatelessWidget {
  const RequestLocationPermissionsDialog({super.key});

  Future<void> onActionPressed(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      Navigator.pop(context);
      Navigator.pushNamed(context, NearbyCenters.id);
    } else if (permission == LocationPermission.deniedForever){
      Navigator.pop(context);
      await showRoundedBarBottomSheet(context, const LocationDeniedDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BasicDialog(
      title: locale.permission_required,
      icon: Icons.not_listed_location_outlined,
      iconColor: Colors.amber,
      body: locale.location_permissions_required,
      actions: [
        FilledButton(
            onPressed: () => onActionPressed(context),
            child: Text(locale.grant_location_access)),
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
