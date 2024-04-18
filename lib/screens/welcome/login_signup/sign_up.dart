import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/screens/welcome/login_signup/login.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/doctype_dropdown.dart';
import 'package:medicheck/widgets/inputs/email_field.dart';
import 'package:medicheck/widgets/inputs/id_field.dart';
import 'package:medicheck/widgets/popups/snackbar/show_snackbar.dart';
import 'package:provider/provider.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../models/notifiers/user_info_notifier.dart';
import '../../../models/responses/plan_response.dart';
import '../../../utils/jwt_service.dart';
import '../../../widgets/inputs/phone_field.dart';
import '../../../widgets/logo/full_logo.dart';
import '../../../styles/app_colors.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/inputs/pwd_field.dart';
import '../../home/home.dart';
import '../../main_page.dart';
import '../welcome.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const String id = 'sign_up';

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _docNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _documentType = 'CEDULA';


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

  void userSignUp() async {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      setState(() => _isLoading = true);
      try {
        var responseData = await ApiService.userSignup(
            _docNoController.text,
            _documentType,
            _passwordController.text,
            _emailController.text,
            _phoneController.text);

        if (responseData!["isSuccess"] == false) {
          showSnackBar(
              context,
              AppLocalizations.of(context).affiliate_not_found,
              MessageType.ERROR);
        } else {
          int? saveJWTResult = await JWTService.saveJWT(responseData['accessToken']);
          if (saveJWTResult == 0){
            var userInfo = await JWTService.decodeJWT();
            int userID = int.parse(userInfo!['IdUsuario']);
            await _fetchUserInfo(userID);
            if (Provider.of<UserInfoModel>(context, listen: false)
                .currentUser !=
                null) context.read<PlanModel>().plans.clear();
            Navigator.pushReplacementNamed(context, MainPage.id);
          }
        }
      } catch (except) {
        print("Sign up error: $except");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _docNoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
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
                  const AppLogo(
                    orientation: LogoOrientation.Vertical,
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
                        child: DocumentTypeDropdown(
                          docType: _documentType,
                          onChanged: (newVal) => setState(() {
                            _documentType = newVal;
                            _docNoController.clear();
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  EmailField(controller: _emailController, autoValidate: true),
                  const SizedBox(height: 16.0),
                  PhoneField(controller: _phoneController, autoValidate: false),
                  const SizedBox(height: 16.0),
                  PasswordField(
                    controller: _passwordController,
                    autoValidate: true,
                    validator: (String? val) => validatePassword(val, context),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  FilledButton(
                      onPressed: _isLoading ? null : () => userSignUp(),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(locale.create_account_cap)),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(locale.existing_account,
                          style: AppStyles.subMediumTextStyle),
                      const SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        child: Text(
                          locale.login_lowercase,
                          style: AppStyles.actionTextStyle,
                        ),
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, Login.id),
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
