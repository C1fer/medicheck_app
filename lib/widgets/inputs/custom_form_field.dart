import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_decorations.dart';

class CustomInputField extends StatelessWidget {
  CustomInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.inputFormatters,
    this.validator,
    this.autoValidateMode,
    this.keyboardType,
    this.maxLength,
    this.decoration,
    required this.obscureText,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final int? maxLength;
  final InputDecoration? decoration;
  bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      maxLength: maxLength,
      keyboardType: keyboardType ?? TextInputType.text,
      autovalidateMode: autoValidateMode,
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: decoration ??
          AppDecorations.formTextFieldDecoration.copyWith(
              hintText: hintText,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: prefixIcon,
                    )
                  : null,
              prefixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? AppColors.jadeGreen
                      : Colors.grey),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: suffixIcon,
                    )
                  : null,
              labelText: hintText),
    );
  }
}
