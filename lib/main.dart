import 'package:flutter/material.dart';
import 'package:medicheck/screens/login/login.dart';
import 'screens/start/splash_screen.dart';
import 'screens/start/onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      title: 'MediCheck',
      home: Splash(),
      initialRoute: Onboarding.id,
      routes: {
        Splash.id: (context) => Splash(),
        Onboarding.id: (context) => Onboarding(),
        Login.id: (context) => Login(),
      },
    );
  }
}
