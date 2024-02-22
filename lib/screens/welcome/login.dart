import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../screens/welcome/forgot_pw.dart';
import '../../screens/welcome/sign_up.dart';
import '../home/home.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import '../../widgets/inputs/custom_form_field.dart';
import '../../widgets/inputs/custom_pwd_field.dart';
import '../../widgets/logo/full_logo.dart';
import '../../widgets/custom_appbar.dart';
import '../../utils/input_validation/validators.dart';
import '../../utils/api/api_service.dart';
import '../../utils/jwt_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = 'login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _documentNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  // User login Logic
  Future<void> loginUser() async {
    setState(() => _isLoading = true);
    if (_formKey.currentState?.validate() ?? false) {
      try {
        var responseData = await ApiService.UserLogin(
            _documentNumberController.text, 'CEDULA', _passwordController.text);
        if (responseData != null) {
          // Store JWT on successful login
          int? saveJWTResult = await JWTService.saveJWT(responseData['accessToken']);
          saveJWTResult == 0 ? Navigator.pushReplacementNamed(context, Home.id) : null;
        } else {
          print('Incorrect Login');
        }
      } catch (except) {
        print(except);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).login_capitalized,
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
                  const SizedBox(height: 30),
                  const FullLogo(
                    width: 66.37,
                    height: 66.36,
                    color: AppColors.jadeGreen,
                    fontSize: 25.68,
                  ),
                  const SizedBox(height: 30),
                  CustomInputField(
                    controller: _documentNumberController,
                    prefixIcon: Icons.person,
                    hintText: AppLocalizations.of(context).ssn,
                    // validator: (val) {
                    //   if (!Validators.isValidEmail(val ?? '')) return 'E';
                    // },
                  ),
                  const SizedBox(height: 16.0),
                  CustomPasswordField(
                    controller: _passwordController,
                    hintText: AppLocalizations.of(context).passwordFieldLabel,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Text(
                        AppLocalizations.of(context).forgot_pw,
                        style: AppStyles.actionTextStyle
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      onTap: () => Navigator.pushNamed(context, ForgotPW.id),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  FilledButton(
                      onPressed: _isLoading ? null : () => loginUser(),
                      child: Text(_isLoading
                          ? '...'
                          : AppLocalizations.of(context).login_capitalized)),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).not_registered,
                          style: AppStyles.subMediumTextStyle),
                      const SizedBox(
                        width: 5.0,
                      ),
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
