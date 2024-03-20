import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/enums.dart';
import '../../../../styles/app_styles.dart';
import '../../../dropdown/custom_dropdown_button.dart';

class EstablishmentFilterDialog extends StatefulWidget {
  EstablishmentFilterDialog(
      {super.key,
        this.typeValue,
        required this.onTypeChanged,
        required this.onButtonPressed});

  String? typeValue;
  final ValueChanged<String?> onTypeChanged;
  final Future<void> Function() onButtonPressed;

  @override
  State<EstablishmentFilterDialog> createState() => _EstablishmentFilterDialogState();
}

class _EstablishmentFilterDialogState extends State<EstablishmentFilterDialog> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text(
              locale.filter_options,
              style: AppStyles.headingTextStyle.copyWith(fontSize: 18.0),
            )),
        const SizedBox(height: 16.0),
        Text(
          locale.type,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        CustomDropdownButton(
            value: widget.typeValue,
            isNullable: true,
            isExpanded: true,
            onChanged: (String? newVal) {
              setState(() => widget.typeValue = newVal);
              widget.onTypeChanged(newVal);
            },
            entries: Constants.establishmentTypes
                .map((String type) => DropdownMenuItem(
              value: type,
              child: Text(type.replaceAll('_', ' ')),
            ))
                .toList()),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: widget.onButtonPressed,
              child: const Text('OK')),
        )
      ],
    );
  }
}
