import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/extensions/string_apis.dart';

import '../../../../models/enums.dart';
import '../../../../styles/app_colors.dart';
import '../../../../styles/app_styles.dart';
import '../../../dropdown/custom_dropdown_button.dart';

class EstablishmentFilterDialog extends StatefulWidget {
  EstablishmentFilterDialog(
      {super.key,
      this.typeValue,
      required this.onTypeChanged,
      required this.onApplyButtonPressed,
      required this.onResetButtonPressed});

  String? typeValue;
  final ValueChanged<String?> onTypeChanged;
  final void Function() onApplyButtonPressed;
  final void Function() onResetButtonPressed;
  @override
  State<EstablishmentFilterDialog> createState() =>
      _EstablishmentFilterDialogState();
}

class _EstablishmentFilterDialogState extends State<EstablishmentFilterDialog> {
  void _resetFields() {
    setState(() {
      widget.typeValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Header(locale),
        const SizedBox(height: 24),
        TypeField(locale),
        const SizedBox(height: 32),
        ActionButtons(locale),
      ],
    );
  }

  Widget Header(AppLocalizations locale) {
    return Row(
      children: [
        const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.jadeGreen,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          locale.filter_options,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 18.0, color: AppColors.jadeGreen),
        ),
      ],
    );
  }

  Widget TypeField(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(
        locale.establishment_type,
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
                    child: Text(type.replaceUnderScores().toProperCaseData()),
                  ))
              .toList())
    ]);
  }

  Widget ActionButtons(AppLocalizations locale) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () {
                _resetFields();
                widget.onResetButtonPressed();
              },
              child: Text(locale.reset)),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: FilledButton(
              onPressed: widget.onApplyButtonPressed,
              child: Text(locale.apply)),
        ),
      ],
    );
  }
}
