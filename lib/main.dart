import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:medicheck/screens/home/coverage/coverage_search.dart';
import 'package:medicheck/screens/home/coverage/saved_coverages.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/screens/home/settings.dart';
import 'package:medicheck/screens/welcome/forgot_pw.dart';
import 'package:medicheck/screens/welcome/login.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:medicheck/screens/welcome/sign_up.dart';
import 'models/locale.dart';
import 'screens/start/splash_screen.dart';
import 'screens/start/onboarding.dart';
import 'screens/home/home.dart';
import 'styles/app_styles.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
          builder: (context, localeModel, child) =>
              MaterialApp(
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'Inter',
                  outlinedButtonTheme:
                  const OutlinedButtonThemeData(
                      style: AppStyles.outlinedButtonStyle),
                  filledButtonTheme:
                  const FilledButtonThemeData(
                      style: AppStyles.primaryButtonStyle),
                  textButtonTheme: const TextButtonThemeData(
                      style: AppStyles.TextButtonStyle),
                ),
                debugShowCheckedModeBanner: false,
                title: 'MediCheck',
                initialRoute: Splash.id,
                routes: {
                  Splash.id: (context) => const Splash(),
                  Onboarding.id: (context) => const Onboarding(),
                  Welcome.id: (context) => const Welcome(),
                  Login.id: (context) => const Login(),
                  SignUp.id: (context) => const SignUp(),
                  ForgotPW.id: (context) => const ForgotPW(),
                  Home.id: (context) => const Home(),
                  EstablishmentsList.id: (
                      context) => const EstablishmentsList(),
                  CoverageSearch.id: (context) => const CoverageSearch(),
                  CoverageDetailView.id: (
                      context) => const CoverageDetailView(),
                  SavedCoverages.id: (context) => const SavedCoverages(),
                  SettingsPage.id: (context) => const SettingsPage(),
                },
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeModel.locale,
              )
      ),
    );
  }
}
