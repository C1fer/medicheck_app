import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/enums.dart';
import '../../../../styles/app_styles.dart';
import '../../../dropdown/custom_dropdown_button.dart';

class NewIncidentDialog extends StatefulWidget {
  NewIncidentDialog(
      {super.key,
        this.categoryValue,
        this.typeValue,
        required this.onCategoryChanged,
        required this.onTypeChanged,
        required this.onButtonPressed});

  String? categoryValue;
  String? typeValue;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onTypeChanged;
  final Future<void> Function() onButtonPressed;

  @override
  State<NewIncidentDialog> createState() => _NewIncidentDialogState();
}

class _NewIncidentDialogState extends State<NewIncidentDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: Column(
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
              entries: Constants.productTypes
                  .map((String type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList()),
          const SizedBox(
            height: 20,
          ),
          Text(locale.category,
              style: AppStyles.headingTextStyle
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          CustomDropdownButton(
              value: widget.categoryValue,
              isNullable: true,
              isExpanded: true,
              onChanged: (String? newVal) {
                setState(() => widget.categoryValue = newVal);
                widget.onCategoryChanged(newVal);
              },
              entries: Constants.productCategories
                  .map((String category) => DropdownMenuItem(
                value: category,
                child: Text(category),
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
      ),
    );
  }
}
