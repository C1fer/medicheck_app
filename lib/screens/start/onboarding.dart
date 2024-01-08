import 'package:flutter/material.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import 'package:medicheck/widgets/step_counter.dart';
import '../../widgets/logo/full_logo.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  static const String id = 'onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _step = 1;
  final int _maxSteps = 3;
  @override
  Widget build(BuildContext context) {
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
                      AppLocalizations.of(context).skip_onboarding,
                      style: AppStyles.mainTextStyle,
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Welcome.id);
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
                child: Text(AppLocalizations.of(context).onboarding_1,
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
                      SizedBox(
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
                        Navigator.pushNamed(context, Welcome.id);
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
