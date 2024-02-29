import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/screens/welcome/pw_reset/new_pw.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/token_field.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/popups/snackbar/show_snackbar.dart';

class ResetTokenInput extends StatefulWidget {
  const ResetTokenInput({super.key});
  static const String id = 'token_input';

  @override
  State<ResetTokenInput> createState() => _ResetTokenInputState();
}

class _ResetTokenInputState extends State<ResetTokenInput> {
  final _formKey = GlobalKey<FormState>();
  final _resetTokenController = TextEditingController();
  bool _isLoading = false;

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    final emailFormatted = '****@${email.split('@').last}';
    final locale = AppLocalizations.of(context);

    print("email: $email");

    // Validate input reset token
    void validateResetToken(String token, email) async {
      if (isFormValid()) {
        setState(() => _isLoading = true);
        try {
          bool response = await ApiService.validateResetToken(token, email);
          if (response) {
            Map<String, String> routeArgs = {"token": token, "email": email};
            Navigator.pushNamed(context, NewPasswordInput.id,
                arguments: routeArgs);
            //Navigate to reset screen
          } else {
            // Handle null response
            showSnackBar(context, locale.invalid_token, MessageType.ERROR);
          }
        } catch (except) {
          print("Error validating token: $except");
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    // Send Email with reset token
    void sendResetToken(String emailAddr) async {
      try {
        bool response = await ApiService.sendResetToken(emailAddr);
        if (response) {
          showSnackBar(context, locale.code_sent, MessageType.SUCCESS);
        } else {
          // Handle null response
          showSnackBar(context, locale.server_error, MessageType.ERROR);
        }
      } catch (except) {
        print("Error sending email: $except");
      } finally {
        setState(() => _isLoading = false);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).new_pw,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  locale.verification_no,
                  style: AppStyles.headingTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  '${locale.reset_token_input_instructions} $emailFormatted',
                  style: AppStyles.mainTextStyle,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ResetTokenField(
                    controller: _resetTokenController,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                FilledButton(
                    onPressed: _isLoading
                        ? null
                        : () => validateResetToken(
                            _resetTokenController.text, email),
                    child: Text(_isLoading ? '...' : locale.verify)),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(locale.code_not_received,
                        style: AppStyles.subMediumTextStyle),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      child: Text(
                        AppLocalizations.of(context).resend_code,
                        style: AppStyles.actionTextStyle,
                      ),
                      onTap: () => sendResetToken(email),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
