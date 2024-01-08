import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_decorations.dart';


class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: AppDecorations.formTextFieldDecoration
          .copyWith(hintText:hintText, prefixIcon: Icon(prefixIcon)),
    );
  }
}