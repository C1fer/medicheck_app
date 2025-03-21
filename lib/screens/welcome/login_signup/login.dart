import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/screens/main_page.dart';
import 'package:provider/provider.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../models/notifiers/user_info_notifier.dart';
import '../../../models/responses/plan_response.dart';
import '../pw_reset/forgot_pw.dart';
import 'sign_up.dart';
import '../../../widgets/doctype_dropdown.dart';
import '../../../widgets/inputs/id_field.dart';
import '../../../widgets/popups/snackbar/show_snackbar.dart';
import '../../home/home.dart';
import '../../../styles/app_styles.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/inputs/pwd_field.dart';
import '../../../widgets/logo/full_logo.dart';
import '../../../widgets/misc/custom_appbar.dart';
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
  @override
  void dispose() {
    super.dispose();
    _docNoController.dispose();
    _passwordController.dispose();
  }

    // Fetch current user info
    Future<bool> _fetchUserInfo(int userID) async {
      var response = await ApiService.getUserById(userID);
      if (response != null){
        context.read<UserInfoModel>().setCurrentUser(response);
        return true;
      }
      return false;
    }
    // Get affiliate plans
    Future<bool> _fetchUserPlans(int userID, PlanModel planProvider) async {
      final PlanResponse? response = await ApiService.getPlansbyUserID(userID);
      if (response != null) {
        planProvider.addPlans(response.data);
        return true;
      }
      return false;
    }

    Future<void> _fetchUserData(int userID) async{
      final bool userLoggedIn = await _fetchUserInfo(userID);
      if (userLoggedIn){
        final planProvider = context.read<PlanModel>();
        await _fetchUserPlans(userID, planProvider);
      }
    }


  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    void userLogin() async {
      bool isFormValid = _formKey.currentState?.validate() ?? false;
      if (isFormValid) {
        setState(() => _isLoading = true);
        try {
          var responseData = await ApiService.userLogin(
              _docNoController.text, _documentType, _passwordController.text);
          if (responseData != null) {
            if (responseData["isSuccess"] == false) {
              showSnackBar(
                  context, locale.wrong_credentials, MessageType.ERROR);
            } else {
              int? saveJWTResult =
                  await JWTService.saveJWT(responseData['accessToken']);
              if (saveJWTResult == 0) {
                var userInfo = await JWTService.decodeJWT();
                int userID = int.parse(userInfo!['IdUsuario']);
                await _fetchUserInfo(userID);
                if (Provider.of<UserInfoModel>(context, listen: false)
                        .currentUser !=
                    null) context.read<PlanModel>().plans.clear();
                Navigator.pushReplacementNamed(context, MainPage.id);
              }
            }
          } else {
            // Handle null response
            showSnackBar(context, locale.server_error, MessageType.ERROR);
          }
        } catch (except) {
          print("Login error: $except");
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.login_capitalized,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: const AppLogo(
                      orientation: LogoOrientation.Vertical,
                      width: 66.37,
                      height: 66.36,
                      color: AppColors.jadeGreen,
                      fontSize: 25.68,
                    ),
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
                        locale.forgot_pw,
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
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(locale.login_capitalized)),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(locale.not_registered,
                          style: AppStyles.subMediumTextStyle),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        child: Text(
                          locale.create_account_low,
                          style: AppStyles.actionTextStyle,
                        ),
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, SignUp.id),
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
