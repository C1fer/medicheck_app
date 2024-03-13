import 'package:flutter/material.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/widgets/inputs/pwd_field.dart';
import 'package:medicheck/widgets/misc/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
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
  Future<void> setNewPassword(String currPwd, String newPwd, String confirmPwd) async {
    try {
      int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
      await ApiService.changeUserPassword(userID, currPwd, newPwd);
      await showCustomDialog(context, Placeholder());
      Navigator.pop(context);
    } catch (ex) {
      print("Error: $ex");
    }
  }

  void onChangePwdButtonPresed() {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      setNewPassword(_currentPWController.text, _newPWController.text,
          _confirmPWController.text);
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
              padding: EdgeInsets.all(24.0),
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
                    autoValidate: false,
                    hintText: locale.current_pwd,
                  ),
                  const SizedBox(height: 16.0),
                  PasswordField(
                      controller: _newPWController,
                      autoValidate: true,
                      hintText: locale.new_pwd),
                  const SizedBox(height: 16.0),
                  PasswordField(
                      controller: _confirmPWController,
                      autoValidate: true,
                      hintText: locale.confirm_pwd),
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
