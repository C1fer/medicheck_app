import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/welcome/login.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:medicheck/screens/welcome/sign_up.dart';
import 'screens/start/splash_screen.dart';
import 'screens/start/onboarding.dart';
import 'screens/home.dart';
import 'lang.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      title: 'MediCheck',
      initialRoute: LangTest.id,
      routes: {
        LangTest.id: (context) => LangTest(),
        Splash.id: (context) => Splash(),
        Onboarding.id: (context) => Onboarding(),
        Welcome.id: (context) => Welcome(),
        Login.id: (context) => Login(),
        SignUp.id: (context) => SignUp(),
        Home.id: (context) => Home(),
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale("es"),
    );
  }
}
