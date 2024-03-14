import 'package:flutter/material.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/utils/input_validation/validators.dart';
import 'package:medicheck/widgets/inputs/pwd_field.dart';
import 'package:medicheck/widgets/misc/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:medicheck/widgets/popups/snackbar/show_snackbar.dart';
import 'package:provider/provider.dart';

import '../../../styles/app_styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  static const String id = 'change_pw';

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPWController = TextEditingController();
  final TextEditingController _newPWController = TextEditingController();
  final TextEditingController _confirmPWController = TextEditingController();

  //TODO: change endpoint on backend
  Future<void> setNewPassword(int userID, String currPwd, String newPwd) async {
    final locale = AppLocalizations.of(context);
    final bool? response = await ApiService.changeUserPassword(userID, currPwd, newPwd);
    if (response != null) {
      if (response) {
        await showCustomDialog(
            context,
            BasicDialog(
              title: locale.success,
              body: locale.pw_reset_success,
            ));
        Navigator.pop(context);
      } else {
        showSnackBar(context, locale.incorrect_current_pwd, MessageType.ERROR);
      }
    } else {
      showSnackBar(context, locale.server_error, MessageType.ERROR);
    }
  }

  void onChangePwdButtonPresed() {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
      setNewPassword(userID, _currentPWController.text, _newPWController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: locale.change_pwd),
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
                    controller: _currentPWController,
                    hintText: locale.current_pwd,
                    autoValidate: false,
                    validator: (String? val) =>
                        validateEmptyInput(val!, context),
                  ),
                  const SizedBox(height: 16.0),
                  PasswordField(
                      controller: _newPWController,
                      hintText: locale.new_pwd,
                      validator: (String? val) =>
                          validatePassword(val, context)),
                  const SizedBox(height: 16.0),
                  PasswordField(
                    controller: _confirmPWController,
                    hintText: locale.confirm_pwd,
                    validator: (String? val) => validateConfirmPassword(
                        _newPWController.text, val, context),
                  ),
                  const SizedBox(height: 40.0),
                  FilledButton(
                      onPressed: () => onChangePwdButtonPresed(),
                      child: Text(locale.change_pwd))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
