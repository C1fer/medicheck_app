import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/input_validation/validation_logic.dart';
import 'custom_form_field.dart';

class PhoneField extends StatefulWidget {
  const PhoneField(
      {super.key, required this.controller, required this.autoValidate});
  final TextEditingController controller;
  final bool autoValidate;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      autoValidateMode:
          widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
      controller: widget.controller,
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      hintText: AppLocalizations.of(context).phoneFieldLabel,
      validator: widget.autoValidate ? (val) => validatePhoneNo(val, context) : null,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
      obscureText: false,
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (text.length == 3) {
      text = '${text.substring(0, 3)}-';
    } else if (text.length == 7) {
      text = '${text.substring(0, 7)}-';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}