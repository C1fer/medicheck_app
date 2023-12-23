import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_decorations.dart';


class CustomInputField extends StatefulWidget {
  const CustomInputField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      onChanged: (val){},
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      decoration: AppDecorations.formTextFieldDecoration
          .copyWith(hintText: widget.hintText, prefixIcon: Icon(widget.prefixIcon)),
    );
  }
}