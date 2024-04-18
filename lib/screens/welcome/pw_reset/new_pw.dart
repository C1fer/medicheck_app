import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/inputs/pwd_field.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/popups/snackbar/show_snackbar.dart';
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
    final locale = AppLocalizations.of(context);

    // Change UserPassword
    void setNewPassword(String newPwd, String confirmPwd) async {
      try {
        bool response = await ApiService.resetPassword(
            args["token"]!, newPwd, args["email"]!);
        if (response) {
          await showCustomDialog(
              context,
              BasicDialog(
                icon: Icons.check_rounded,
                title: locale.success,
                body: locale.pw_reset_success,
              ));
          await Navigator.pushReplacementNamed(context, Welcome.id);
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

    void onButtonPresed() {
      bool isFormValid = _formKey.currentState?.validate() ?? false;
      if (isFormValid && _isLoading == false) {
        setState(() => _isLoading = true);
        setNewPassword(
            _passwordController.text, _passwordConfirmController.text);
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
                    controller: _passwordController,
                    validator: (String? val) => validatePassword(val, context),
                  ),
                  const SizedBox(height: 16),
                  PasswordField(
                    controller: _passwordConfirmController,
                    validator: (String? val) => validateConfirmPassword(
                        _passwordController.text, val, context),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  FilledButton(
                      onPressed: () => onButtonPresed(),
                      child: Text(_isLoading ? '...' : locale.new_pw)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
