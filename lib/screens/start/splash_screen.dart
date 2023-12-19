import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:medicheck/widgets/vertical_logo.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static const String id = 'splash_screen';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), ()  {
      Navigator.pushReplacementNamed(context, Onboarding.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF199A8E),
      body: SafeArea(
        child: Center(child: VerticalLogo(color: Colors.white)),
      ),
    );
  }
}
