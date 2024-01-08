import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/forgot_pw.dart';
import 'package:medicheck/screens/welcome/login.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:medicheck/screens/welcome/sign_up.dart';
import 'screens/start/splash_screen.dart';
import 'screens/start/onboarding.dart';
import 'screens/home.dart';
import 'styles/app_styles.dart';
import 'utils/local_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          outlinedButtonTheme:
              OutlinedButtonThemeData(style: AppStyles.outlinedButtonStyle),
          filledButtonTheme:
              FilledButtonThemeData(style: AppStyles.primaryButtonStyle),
        textButtonTheme: TextButtonThemeData(style: AppStyles.TextButtonStyle),
      ),
      debugShowCheckedModeBanner: false,
      title: 'MediCheck',
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        Onboarding.id: (context) => Onboarding(),
        Welcome.id: (context) => Welcome(),
        Login.id: (context) => Login(),
        SignUp.id: (context) => SignUp(),
        ForgotPW.id: (context) => ForgotPW(),
        Home.id: (context) => Home(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale("es"),
    );
  }
}
