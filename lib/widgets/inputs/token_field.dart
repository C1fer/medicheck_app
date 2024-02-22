import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetTokenField extends StatefulWidget {
  const ResetTokenField({super.key, required this.controller});

  final TextEditingController controller;
  @override
  State<ResetTokenField> createState() => _ResetTokenFieldState();
}

class _ResetTokenFieldState extends State<ResetTokenField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      autoDismissKeyboard: true,
      textStyle: AppStyles.headingTextStyle.copyWith(fontSize: 24.0),
      animationDuration: const Duration(milliseconds: 100),
      validator: (val) => validateResetTokenInput(val, context),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      pinTheme: PinTheme(
        borderRadius: BorderRadius.circular(10),
        borderWidth: 1.0,
        fieldHeight: 64,
        fieldWidth: 64,
        shape: PinCodeFieldShape.box,
        inactiveColor: AppColors.deeperGray,
        activeColor: AppColors.jadeGreen,
        selectedColor: AppColors.jadeGreen,
      ),

    );
  }
}
