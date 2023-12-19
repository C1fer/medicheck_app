import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:medicheck/widgets/vertical_logo.dart';
import 'package:medicheck/styles/app_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static const String id = 'splash_screen';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, Onboarding.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.jadeGreen,
      body: SafeArea(
        child: Center(
            child: VerticalLogo(
          color: Colors.white,
          fontSize: 50.11,
              width:129.54,
              height:129.52,
        )),
      ),
    );
  }
}
