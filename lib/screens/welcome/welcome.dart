import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_styles.dart';
import '../../widgets/logo/full_logo.dart';
import 'login.dart';
import 'sign_up.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});
  static const String id = 'welcome';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FullLogo(
                color: AppColors.jadeGreen,
                fontSize: 25.68,
                width: 66.37,
                height: 66.36),
            SizedBox(height: 25.0,),
            Text(
              AppLocalizations.of(context).welcome_msg,
              style: AppStyles.headingTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0,),
            Text(
              AppLocalizations.of(context).welcome_copy,
              style: AppStyles.subTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35.0,),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
              child: Text(AppLocalizations.of(context).login_capitalized),
            ),
            SizedBox(height: 16.0,),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, SignUp.id);
              },
              child: Text(AppLocalizations.of(context).signup),
            )
          ],
        ),
      ));
  }
}
