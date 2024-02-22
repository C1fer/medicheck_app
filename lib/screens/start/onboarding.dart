import 'package:flutter/material.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import 'package:medicheck/widgets/step_counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  static const String id = 'onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _step = 1;
  final _maxSteps = 3;


  void _completeOnboarding()async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.setBool('onboarding_completed', true);
    Navigator.pushReplacementNamed(context, Welcome.id);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    List<String> onboarding_msgs = [localization.onboarding_1, localization.onboarding_2, localization.onboarding_3];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text(
                      localization.skip_onboarding,
                      style: AppStyles.mainTextStyle,
                    ),
                    onTap: () {
                      _completeOnboarding();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 315,
                height: 441,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/onboarding_${_step}.jpg"),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(onboarding_msgs[_step-1],
                    style: AppStyles.headingTextStyle),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (int i = 1; i < _maxSteps + 1; i++)
                        StepCounter(i, _step),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    backgroundColor: AppColors.jadeGreen,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_step < _maxSteps) {
                        setState(() {
                          _step++;
                        });
                      } else {
                        _completeOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
