import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/input_validation/validation_logic.dart';
import 'custom_form_field.dart';


class DocNoField extends StatefulWidget {
  DocNoField({super.key, required this.controller, required this.autoValidate, required this.docType});
  final TextEditingController controller;
  final bool autoValidate;
  String docType;

  @override
  State<DocNoField> createState() => _DocNoFieldState();
}

class _DocNoFieldState extends State<DocNoField> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    int _maxLength = widget.docType == "CEDULA" ? 11: 9;
    return CustomInputField(
      autoValidateMode: widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
      controller: widget.controller,
      prefixIcon: SvgPicture.asset('assets/icons/user-outline.svg'),
      keyboardType: TextInputType.number,
      hintText: widget.docType == "CEDULA" ? locale.national_id_card_full: locale.ssn_full,
      validator: (val) => validateID(val, widget.docType, context),
      obscureText: false,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxLength), FilteringTextInputFormatter.digitsOnly],
    );
  }
}
