import 'package:flutter/material.dart';
import 'package:medicheck/widgets/inputs/custom_form_field.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      controller: controller,
      obscureText: false,
      maxLength: 255,
      maxLines: null,
    );
  }
}
