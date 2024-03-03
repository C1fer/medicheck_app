import 'package:flutter/material.dart';
import 'package:medicheck/screens/home/home.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:medicheck/utils/cached_coverages.dart';
import 'package:provider/provider.dart';
import '../../models/user_info_notifier.dart';
import '../../utils/api/api_service.dart';
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
    _initCheck();
  }

  // Check if session is active
  void _initCheck() async {
    String? accessToken = await JWTService.readJWT();
    if (accessToken != null) {
      try {
        var userInfo = await JWTService.decodeJWT();
        int userID = int.parse(userInfo!['IdUsuario']);
        await _fetchUserInfo(userID);
      }
      catch(except){
        print("Error fetching user info: $except");
      }
    }
    _redirectUser();
  }

  // User redirection logic
  void _redirectUser() async {
    final userProvider = Provider.of<UserInfoModel>(context, listen: false);
    if (userProvider.curentUser != null) {
      Navigator.pushReplacementNamed(context, Home.id);
    } else {
      // Redirect to Welcome screen if user had completed onboarding
      final localStorage = await SharedPreferences.getInstance();
      final bool? onboardingCompleted = localStorage.getBool('onboarding_completed');

      final String redirectRoute = onboardingCompleted! ? Welcome.id : Onboarding.id;
      Navigator.pushReplacementNamed(context, redirectRoute);
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
