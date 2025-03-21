import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/screens/welcome/pw_reset/reset_token.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/email_field.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/popups/dialog/dialogs/basic_dialog.dart';
import '../../../widgets/popups/snackbar/show_snackbar.dart';

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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    // Send pwd reset token
    void sendResetToken(String emailAddr) async {
      bool isFormValid = _formKey.currentState?.validate() ?? false;
      if (isFormValid) {
        setState(() => _isLoading = true);
        try {
          _isemailValid = await ApiService.sendResetToken(emailAddr);
          if (_isemailValid!)
            Navigator.pushReplacementNamed(context, ResetTokenInput.id,
                arguments: emailAddr);
        } catch (except) {
          showSnackBar(context, locale.server_error, MessageType.ERROR);
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).new_pw,
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
                  Text(
                    locale.new_pw_heading,
                    style: AppStyles.headingTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locale.new_pw_mail_input_instructions,
                    style: AppStyles.mainTextStyle,
                  ),
                  const SizedBox(height: 30),
                  EmailField(controller: _emailController, autoValidate: false),
                  const SizedBox(
                    height: 25.0,
                  ),
                  FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () => sendResetToken(_emailController.text),
                      child: _isLoading ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) : Text(locale.send_reset_pw_code)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
