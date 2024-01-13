import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/sign_up.dart';
import 'package:medicheck/styles/app_styles.dart';
import '../../widgets/heading_back.dart';
import '../../widgets/inputs/custom_form_field.dart';
import '../../widgets/logo/full_logo.dart';
import '../../utils/validators.dart';
import '../../styles/app_colors.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({super.key});
  static const String id = 'forgot_pw';

  @override
  State<ForgotPW> createState() => _ForgotPWState();
}

class _ForgotPWState extends State<ForgotPW> {
  @override
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Heading(msg: AppLocalizations.of(context).new_pw),
                SizedBox(height: 30),
                Text(AppLocalizations.of(context).new_pw_heading, style: AppStyles.headingTextStyle,),
                SizedBox(height: 8),
                Text(AppLocalizations.of(context).new_pw_mail_input_instructions, style: AppStyles.mainTextStyle,),
                SizedBox(height: 30),
                CustomInputField(
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  hintText: AppLocalizations.of(context).emailFieldLabel,
                  validator: (val) {
                    if (!Validators.isValidEmail(val ?? '')) return 'E';
                  },
                ),
                SizedBox(height: 25.0,),
                FilledButton(
                    onPressed: () {/*Login*/},
                    child: Text(AppLocalizations.of(context).send_reset_pw_code)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
