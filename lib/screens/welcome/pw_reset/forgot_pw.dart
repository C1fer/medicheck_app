import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/pw_reset/reset_token.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/email_field.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/heading_back.dart';
import '../../../widgets/snackbar.dart';

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

  // Send pwd reset token
  void sendResetToken() async {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      setState(() => _isLoading = true);
      try {
        await ApiService.getResetToken(_emailController.text);
        Navigator.pushReplacementNamed(context, ResetTokenInput.id, arguments: _emailController.text);
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Heading(msg: locale.new_pw),
                const SizedBox(height: 30),
                Text(locale.new_pw_heading, style: AppStyles.headingTextStyle,),
                const SizedBox(height: 8),
                Text(locale.new_pw_mail_input_instructions, style: AppStyles.mainTextStyle,),
                const SizedBox(height: 30),
                EmailField(controller: _emailController, autoValidate: false),
                const SizedBox(height: 25.0,),
                FilledButton(
                    onPressed: _isLoading ? null : () => sendResetToken(),
                    child: Text(_isLoading ? '...' : locale.send_reset_pw_code)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
