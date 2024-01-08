import 'package:flutter/material.dart';
import '../styles/app_decorations.dart';
import '../styles/app_colors.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureState = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureState,
      validator: widget.validator,
      decoration: AppDecorations.formTextFieldDecoration.copyWith(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.lock),
          prefixIconColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.focused)
                  ? AppColors.jadeGreen
                  : Colors.grey),
          suffixIcon: PasswordToggle()),
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
        child: Icon(_obscureState ? hidePwd : revealPwd));
  }
}
