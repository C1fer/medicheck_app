import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/inputs/pwd_field.dart';
import 'package:medicheck/widgets/inputs/token_field.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/heading_back.dart';
import '../../../widgets/snackbar.dart';
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

  bool isFormValid(){
    return _formKey.currentState?.validate() ?? false;
  }


  @override
  Widget build(BuildContext context) {
    final resetToken = ModalRoute.of(context)!.settings.arguments as String;
    final locale = AppLocalizations.of(context);

    // Change UserPassword
    void setNewPassword(String new_pwd, String confirm_pwd) async {
      if (isFormValid() && new_pwd == confirm_pwd) {
        setState(() => _isLoading = true);
        try {
          bool response = await ApiService.resetPassword(resetToken, _passwordController.text);
          if (response) {
            showCustomSnackBar(context, locale.pw_reset_success);
            Navigator.pushReplacementNamed(context, Welcome.id);
          }
          else {
            // Handle null response
            showCustomSnackBar(context, "Null response from server");
          }
        } catch (except) {
          print("Error sending email: $except");
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

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
                Text(locale.create_new_pw, style: AppStyles.headingTextStyle,),
                const SizedBox(height: 8),
                Text(locale.create_new_pw_instructions, style: AppStyles.mainTextStyle,),
                const SizedBox(height: 32),
                PasswordField(controller: _passwordController, autoValidate: true),
                PasswordField(controller: _passwordConfirmController, autoValidate: true),
                const SizedBox(height: 40.0,),
                FilledButton(
                    onPressed: _isLoading ? null : () => setNewPassword(_passwordController.text, _passwordConfirmController.text),
                    child: Text(_isLoading ? '...' : locale.new_pw)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
