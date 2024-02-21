import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/login.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/utils/api/api_service.dart';
import '../../widgets/inputs/custom_form_field.dart';
import '../../widgets/logo/full_logo.dart';
import '../../utils/validators.dart';
import '../../styles/app_colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/inputs/custom_pwd_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const String id = 'sign_up';

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _docNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _docType = 'CEDULA';

  void userSignUp() async {
    bool? isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      setState(() => _isLoading = true);
      try {
        await ApiService.UserSignup(
            _docNoController.text, _docType, _passwordController.text, _emailController.text, '');
      } catch (except) {
        print("Sign up error: $except");
      } finally {
        setState(() => _isLoading = false);
      }
    }
    else({
      print('Invalid form')
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context).signup),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const FullLogo(
                    width: 66.37,
                    height: 66.36,
                    color: AppColors.jadeGreen,
                    fontSize: 25.68,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomInputField(
                          controller: _docNoController,
                          prefixIcon: Icons.person,
                          hintText: AppLocalizations.of(context).ssn,
                          validator: (val) {
                            if (!Validators.isValidEmail(val ?? '')) return 'E';
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButton(
                            value: _docType,
                            items: [
                              DropdownMenuItem(
                                child: Text('Cédula'),
                                value: 'CEDULA',
                              ),
                              DropdownMenuItem(
                                child: Text('NSS'),
                                value: 'NSS',
                              ),
                              DropdownMenuItem(
                                child: Text('Contrato'),
                                value: 'CONTRATO',
                              )
                            ],
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() => _docType = value);
                              }
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  CustomInputField(
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    hintText: AppLocalizations.of(context).emailFieldLabel,
                    validator: (val) {
                      if (!Validators.isValidEmail(val ?? '')) return 'E';
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomPasswordField(
                    controller: _passwordController,
                    hintText: AppLocalizations.of(context).passwordFieldLabel,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  FilledButton(
                      onPressed: _isLoading ? null : () => userSignUp(),
                      child: Text(_isLoading
                          ? '...'
                          : AppLocalizations.of(context).create_account_cap)),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).existing_account,
                          style: AppStyles.subMediumTextStyle),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context).login_lowercase,
                          style: AppStyles.actionTextStyle,
                        ),
                        onTap: () => Navigator.pushNamed(context, Login.id),
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
