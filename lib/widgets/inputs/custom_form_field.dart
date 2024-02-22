import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
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
      decoration: decoration ?? AppDecorations.formTextFieldDecoration
          .copyWith(hintText: hintText, prefixIcon: Icon(prefixIcon), labelText: hintText),
    );
  }
}
