import 'dart:io';

import 'package:medicheck/screens/main_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../screens/home/home.dart';
import '../../screens/welcome/welcome.dart';
import '../../widgets/popups/snackbar/show_snackbar.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../utils/api/api_service.dart';
import 'onboarding.dart';
import '../../widgets/logo/full_logo.dart';
import '../../styles/app_colors.dart';
import '../../utils/jwt_service.dart';

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
    _isServerAlive();
  }

  void _isServerAlive() async {
    final bool response = await ApiService.checkHealth();
    if (response) {
      _initCheck();
    } else {
      showSnackBar(context, "Unable to reach server", MessageType.ERROR);
      await Future.delayed(const Duration(seconds: 5)).then((value) => exit(0));
    }
  }

  // Check if session is active
  void _initCheck() async {
    String? accessToken = await JWTService.readJWT();
    if (accessToken != null) {
      try {
        var userInfo = await JWTService.decodeJWT();
        int userID = int.parse(userInfo!['IdUsuario']);
        await _fetchUserInfo(userID);
      } catch (except) {
        print("Error fetching user info: $except");
      }
    }
    _redirectUser();
  }

  // User redirection logic
  void _redirectUser() async {
    final userProvider = Provider.of<UserInfoModel>(context, listen: false);
    if (userProvider.currentUser != null) {
      Navigator.pushReplacementNamed(context, MainPage.id);
    } else {
      // Redirect to Welcome screen if user had completed onboarding
      final localStorage = await SharedPreferences.getInstance();
      final bool? onboardingCompleted =
          localStorage.getBool('onboarding_completed');

      if (onboardingCompleted != null) {
        if (onboardingCompleted!) {
          Navigator.pushReplacementNamed(context, Welcome.id);
        }
      }
      Navigator.pushReplacementNamed(context, Onboarding.id);
    }
  }

  // Fetch current user info
  Future<void> _fetchUserInfo(int userID) async {
    var response = await ApiService.getUserById(userID);
    if (response != null)
      Provider.of<UserInfoModel>(context, listen: false)
          .setCurrentUser(response);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.jadeGreen,
      body: SafeArea(
        child: Center(
            child: AppLogo(
              orientation: LogoOrientation.Vertical,
          color: Colors.white,
          fontSize: 50.11,
          width: 129.54,
          height: 129.52,
        )),
      ),
    );
  }
}
