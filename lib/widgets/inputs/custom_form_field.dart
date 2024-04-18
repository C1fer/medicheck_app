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
      this.maxLines = 1,
      this.floatingLabelBehavior,
      this.onTap,
      this.readOnly = false,
      this.expands = false,
      this.minLines})
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
  final FloatingLabelBehavior? floatingLabelBehavior;

  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  bool obscureText;
  final void Function()? onTap;
  bool readOnly;
  bool expands;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap,
      child: TextFormField(
        expands: widget.expands,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        autovalidateMode: widget.autoValidateMode,
        controller: widget.controller,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        readOnly: false,
        decoration: widget.decoration ??
            AppDecorations.formTextFieldDecoration.copyWith(
                floatingLabelBehavior:
                    widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
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
      ),
    );
  }
}
