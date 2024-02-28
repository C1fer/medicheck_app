import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pw_reset/forgot_pw.dart';
import 'sign_up.dart';
import '../../../widgets/doctype_dropdown.dart';
import '../../../widgets/inputs/id_field.dart';
import '../../../widgets/popups/snackbar.dart';
import '../../home/home.dart';
import '../../../styles/app_styles.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/inputs/pwd_field.dart';
import '../../../widgets/logo/full_logo.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import '../../../utils/jwt_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = 'login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _docNoController = TextEditingController();
  final _passwordController = TextEditingController();
  String _documentType = 'CEDULA';

  // User login Logic
  void userLogin() async {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      setState(() => _isLoading = true);
      try {
        var responseData = await ApiService.userLogin(
            _docNoController.text,
            _documentType,
            _passwordController.text);
        if (responseData != null) {
          if (responseData["isSuccess"] == false) {
            showCustomSnackBar(context, AppLocalizations.of(context).wrong_credentials);
          } else {
            int? saveJWTResult =
            await JWTService.saveJWT(responseData['accessToken']);
            saveJWTResult == 0
                ? Navigator.pushReplacementNamed(context, Home.id)
                : null;
          }
        } else {
          // Handle null response
          showCustomSnackBar(context, "Null response from server");
        }
      } catch (except) {
        print("Login error: $except");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _docNoController.dispose();
    _passwordController.dispose();
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 5,
                          child: DocNoField(
                            controller: _docNoController,
                            docType: _documentType,
                            autoValidate: true,
                          )),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: DocumentTypeDropdown(
                            docType: _documentType,
                            onChanged: (newVal) => setState(() {
                              _documentType = newVal;
                              _docNoController.clear();
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  PasswordField(
                    controller: _passwordController,
                    autoValidate: false,
                  ),
                  const SizedBox(height: 16.0),
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
                      onPressed: _isLoading ? null : () => userLogin(),
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
                        onTap: () => Navigator.pushReplacementNamed(context, SignUp.id),
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
