import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/forgot_pw.dart';
import 'package:medicheck/screens/welcome/sign_up.dart';
import 'package:medicheck/styles/app_styles.dart';
import '../../widgets/custom_form_field.dart';
import '../../widgets/logo/full_logo.dart';
import '../../utils/validators.dart';
import '../../styles/app_colors.dart';
import '../../widgets/custom_appbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = 'login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context).login_capitalized,),
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
                  SizedBox(height: 30),
                  FullLogo(width: 66.37, height: 66.36, color: AppColors.jadeGreen,fontSize: 25.68,),
                  SizedBox(height: 30),
                  CustomInputField(
                    prefixIcon: Icons.email_outlined,
                    hintText: AppLocalizations.of(context).emailFieldLabel,
                    validator: (val) {
                      if (!Validators.isValidEmail(val ?? '')) return 'E';
                    },
                  ),
                  SizedBox(height: 16.0),
                  CustomInputField(
                    prefixIcon: Icons.lock,
                    hintText: AppLocalizations.of(context).passwordFieldLabel,
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        AppLocalizations.of(context).forgot_pw,
                        style: AppStyles.actionTextStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                      onTap: () => Navigator.pushNamed(context, ForgotPW.id),
                    ),
                  ),
                  SizedBox(height: 25.0,),
                  FilledButton(
                      onPressed: () {/*Login*/},
                      child: Text(AppLocalizations.of(context).login_capitalized)),
                  SizedBox(height: 24.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).not_registered,
                          style: AppStyles.subTextStyle),
                      SizedBox(width: 5.0,),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).create_account_low,
                          style: AppStyles.actionTextStyle,
                        ),
                        onTap: () => Navigator.pushNamed(context, SignUp.id),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
