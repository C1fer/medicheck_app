import 'package:flutter/material.dart';
import 'package:medicheck/screens/home.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'onboarding.dart';
import 'package:medicheck/widgets/logo/full_logo.dart';
import 'package:medicheck/styles/app_colors.dart';
import '../../utils/jwt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static const String id = 'splash_screen';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  void _redirectUser() async {
    // Redirect to home screen if JWT is available
    String? accessToken = await JWTService.readJWT();
    if (accessToken != null) {
      Navigator.pushReplacementNamed(context, Home.id);
    } else {
      // Redirect to Welcome screen if user had completed onboarding
      final localStorage = await SharedPreferences.getInstance();
      final bool? onboardingCompleted = localStorage.getBool('onboarding_completed');
      onboardingCompleted == true
          ? Navigator.pushReplacementNamed(context, Welcome.id)
          : Navigator.pushReplacementNamed(context, Onboarding.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.jadeGreen,
      body: SafeArea(
        child: Center(
            child: FullLogo(
          color: Colors.white,
          fontSize: 50.11,
          width: 129.54,
          height: 129.52,
        )),
      ),
    );
  }
}
