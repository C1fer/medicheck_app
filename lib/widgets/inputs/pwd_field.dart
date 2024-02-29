import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/inputs/custom_form_field.dart';
import '../../styles/app_decorations.dart';
import '../../styles/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    required this.controller,
    required this.autoValidate,
  }) : super(key: key);

  final TextEditingController controller;
  final bool autoValidate;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureState = true;

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: widget.controller,
      obscureText: _obscureState,
      autoValidateMode: widget.autoValidate ? AutovalidateMode.onUserInteraction : null,
      validator: widget.autoValidate ? (val) => validatePassword(val, context): null,
      hintText: AppLocalizations.of(context).passwordFieldLabel,
      prefixIcon: SvgPicture.asset('assets/icons/lock.svg'),
      suffixIcon: PasswordToggle(),
    );
  }

  Widget PasswordToggle() {
    void changeIcon() {
      setState(() => _obscureState = !_obscureState);
    }

    const revealPwd = Icons.remove_red_eye;
    const hidePwd = Icons.remove_red_eye_outlined;
    return GestureDetector(
        onTap: changeIcon,
        child: Icon(_obscureState ? hidePwd : revealPwd, color: AppColors.lightGray,));
  }
}
