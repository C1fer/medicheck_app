import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_decorations.dart';

class CustomInputField extends StatefulWidget {
  CustomInputField(
      {Key? key,
      required this.controller,
      this.hintText,
      this.prefixIcon,
      this.inputFormatters,
      this.validator,
      this.autoValidateMode,
      this.keyboardType,
      this.maxLength,
      this.decoration,
      this.obscureText = false,
      this.suffixIcon,
      this.maxLines = 1})
      : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final int? maxLength;

  final int? maxLines;
  final InputDecoration? decoration;
  bool obscureText;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      autovalidateMode: widget.autoValidateMode,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      decoration: widget.decoration ??
          AppDecorations.formTextFieldDecoration.copyWith(
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: widget.prefixIcon,
                    )
                  : null,
              prefixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? AppColors.jadeGreen
                      : Colors.grey),
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: widget.suffixIcon,
                    )
                  : null,
              labelText: widget.hintText),
    );
  }
}
