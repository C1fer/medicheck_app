import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/notifiers/recent_query_notifier.dart';
import 'package:medicheck/models/notifiers/saved_products_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:medicheck/screens/home/coverage/product_search.dart';
import 'package:medicheck/screens/home/coverage/nearby_centers.dart';
import 'package:medicheck/screens/home/coverage/saved_products.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/screens/home/incidents/incident_reports.dart';
import 'package:medicheck/screens/home/settings/change_pw.dart';
import 'package:medicheck/screens/home/settings/settings.dart';
import 'package:medicheck/screens/welcome/pw_reset/forgot_pw.dart';
import 'package:medicheck/screens/welcome/login_signup/login.dart';
import 'package:medicheck/screens/welcome/pw_reset/new_pw.dart';
import 'package:medicheck/screens/welcome/pw_reset/reset_token.dart';
import 'package:medicheck/screens/welcome/welcome.dart';
import 'package:medicheck/screens/welcome/login_signup/sign_up.dart';
import 'models/notifiers/localeNotifier.dart';
import 'screens/start/splash_screen.dart';
import 'screens/start/onboarding.dart';
import 'screens/home/home.dart';
import 'styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleModel()),
        ChangeNotifierProvider(create: (context) => UserInfoModel()),
        ChangeNotifierProvider(create: (context) => SavedProductModel()),
        ChangeNotifierProvider(create: (context) => PlanModel()),
        ChangeNotifierProvider(create: (context) => ViewedCoverageModel())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
          builder: (context, localeModel, child) => MaterialApp(
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'Inter',
                  outlinedButtonTheme: const OutlinedButtonThemeData(
                      style: AppStyles.outlinedButtonStyle),
                  filledButtonTheme: const FilledButtonThemeData(
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
                  EstablishmentsList.id: (context) =>
                      const EstablishmentsList(),
                  ProductSearch.id: (context) => const ProductSearch(),
                  CoverageDetailView.id: (context) =>
                      const CoverageDetailView(),
                  SavedProducts.id: (context) => const SavedProducts(),
                  SettingsPage.id: (context) => const SettingsPage(),
                  ResetTokenInput.id: (context) => const ResetTokenInput(),
                  NewPasswordInput.id: (context) => const NewPasswordInput(),
                  ChangePassword.id: (context) => const ChangePassword(),
                  IncidentReports.id: (context) => const IncidentReports(),
                  NearbyCenters.id: (context) => const NearbyCenters()
                },
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeModel.locale,
              )),
    );
  }
}
