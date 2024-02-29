import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/input_validation/validation_logic.dart';
import 'custom_form_field.dart';


class EmailField extends StatefulWidget {
  const EmailField({super.key, required this.controller, required this.autoValidate});
  final TextEditingController controller;
  final bool autoValidate;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return CustomInputField(
        autoValidateMode: widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
        controller: widget.controller,
        prefixIcon: SvgPicture.asset('assets/icons/mail.svg'),
        keyboardType: TextInputType.emailAddress,
        hintText: AppLocalizations.of(context).emailFieldLabel,
        validator: (val) => validateEmail(val, context),
        obscureText: false,
    );
  }
}
