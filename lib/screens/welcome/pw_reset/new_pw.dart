import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/pwd_field.dart';
import 'package:medicheck/widgets/popups/alert.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/heading_back.dart';
import '../../../widgets/popups/snackbar.dart';
import '../welcome.dart';

class NewPasswordInput extends StatefulWidget {
  const NewPasswordInput({super.key});
  static const String id = 'new_password';

  @override
  State<NewPasswordInput> createState() => _NewPasswordInputState();
}

class _NewPasswordInputState extends State<NewPasswordInput> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isLoading = false;

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    print("args: $args");
    final locale = AppLocalizations.of(context);

    // Change UserPassword
    void setNewPassword(String new_pwd, String confirm_pwd) async {
      if (isFormValid()) {
        setState(() => _isLoading = true);
        try {
          bool response = await ApiService.resetPassword(
              args["token"]!, new_pwd, args["email"]!);
          if (response) {
            await showAlertDialog(context, locale.success,
                body: locale.pw_reset_success);
            await Navigator.pushReplacementNamed(context, Welcome.id);
          } else {
            // Handle null response
            showCustomSnackBar(context, locale.server_error);
          }
        } catch (except) {
          print("Error sending email: $except");
        } finally {
          setState(() => _isLoading = false);
        }
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
                  locale.create_new_pw,
                  style: AppStyles.headingTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  locale.create_new_pw_instructions,
                  style: AppStyles.mainTextStyle,
                ),
                const SizedBox(height: 32),
                PasswordField(
                    controller: _passwordController, autoValidate: true),
                const SizedBox(height: 16),
                PasswordField(
                    controller: _passwordConfirmController, autoValidate: true),
                const SizedBox(
                  height: 40.0,
                ),
                FilledButton(
                    onPressed: _isLoading ||
                            _passwordConfirmController.text !=
                                _passwordConfirmController.text
                        ? null
                        : () => setNewPassword(_passwordController.text,
                            _passwordConfirmController.text),
                    child: Text(_isLoading ? '...' : locale.new_pw)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
