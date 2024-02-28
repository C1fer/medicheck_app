import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/pw_reset/reset_token.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/email_field.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/heading_back.dart';
import '../../../widgets/popups/snackbar.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});
  static const String id = 'forgot_pw';

  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool? _isemailValid;

  // Send pwd reset token
  void sendResetToken(String emailAddr) async {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      setState(() => _isLoading = true);
      try {
        _isemailValid = await ApiService.sendResetToken(emailAddr);
        Navigator.pushReplacementNamed(context, ResetTokenInput.id, arguments: emailAddr);
      } catch (except) {
        print("Error sending email: $except");
        showCustomSnackBar(context, "Null response from server");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).new_pw_heading,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text(locale.new_pw_heading, style: AppStyles.headingTextStyle,),
                  const SizedBox(height: 8),
                  Text(locale.new_pw_mail_input_instructions, style: AppStyles.mainTextStyle,),
                  const SizedBox(height: 30),
                  EmailField(controller: _emailController, autoValidate: false),
                  const SizedBox(height: 25.0,),
                  FilledButton(
                      onPressed: _isLoading ? null : () => sendResetToken(_emailController.text),
                      child: Text(_isLoading ? '...' : locale.send_reset_pw_code)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
