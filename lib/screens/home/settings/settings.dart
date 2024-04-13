import 'package:flutter/material.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/screens/home/settings/change_pw.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/cards/settings_card.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/basic_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/log_out_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import '../../../models/plan.dart';
import '../../../widgets/dropdown/custom_dropdown_button.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../../utils/jwt_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/notifiers/localeNotifier.dart';
import '../../welcome/welcome.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const String id = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void userLogOut() async {
    await showCustomDialog(context, LogOutDialog());
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    List<Plan> userPlans = context.read<PlanModel>().plans;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_info_heading,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                UserInfo(locale),
                const SizedBox(
                  height: 15,
                ),
                if (userPlans.length > 1)
                  Column(children: [
                    PlanSelect(locale),
                    const SizedBox(
                      height: 15,
                    ),
                  ]),
                LangSelect(locale),
                const SizedBox(
                  height: 20,
                ),
                PwdChange(locale),
                const SizedBox(
                  height: 20,
                ),
                LogOut(locale)
              ],
            )),
      ),
    );
  }

  Widget UserInfo(AppLocalizations locale) {
    return SettingCard(
        content: Consumer<UserInfoModel>(
      builder: (context, userModel, _) => Column(
        children: [
          Text(
            '${userModel.currentUser!.nombre} ${userModel.currentUser!.apellidos}',
            style: AppStyles.settingTextStyle,
          ),
          Text(
            userModel.currentUser!.correo!,
            style: AppStyles.subSmallTextStyle,
          ),
          const SizedBox(
            height: 24,
          ),
          Consumer<PlanModel>(
              builder: (context, planModel, _) => Row(
                    children: [
                      // Expanded(
                      //   child: _InfoSection(
                      //       userModel.currentUser!.tipoDocumento == "NSS"
                      //           ? locale.ssn_abbrv
                      //           : locale.national_id_card_abbrv,
                      //       userModel.currentUser!.noDocumento!),
                      // ),
                      // SizedBox(width: 10,),
                      Expanded(
                        child: _InfoSection(
                            locale.insurer,
                            planModel
                                .selectedPlan!.idAseguradoraNavigation!.nombre),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _InfoSection(
                            locale.plan, planModel.selectedPlan!.descripcion),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _InfoSection(
                            locale.plan_modality, planModel.selectedPlan!.idRegimenNavigation.descripcion.toSentenceCase()),
                      ),
                    ],
                  ))
        ],
      ),
    ));
  }

  Widget PlanSelect(AppLocalizations locale) {
    return SettingCard(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.plan,
              style: AppStyles.settingTextStyle,
            ),
            Consumer<PlanModel>(
                builder: (context, planModel, _) => planModel.plans.length > 1
                    ? DropdownButton(
                    borderRadius: BorderRadius.circular(24.0),
                    value: planModel.selectedPlanID.toString(),
                    onChanged: (String? newPlanID) =>
                        planModel.updateSelectedPlan(newPlanID!),
                    items: planModel.plans
                        .map((Plan plan) => DropdownMenuItem(
                      value: plan.idPlan.toString(),
                      child: Text(plan.descripcion),
                    ))
                        .toList())
                    : Text(
                  planModel.selectedPlan!.descripcion,
                  style: AppStyles.settingTextStyle
                      .copyWith(fontWeight: FontWeight.w500),
                ))
          ],
        ));
  }

  Widget LangSelect(AppLocalizations locale) {
    return SettingCard(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(locale.change_lang.toProperCase(), style: AppStyles.settingTextStyle),
          Consumer<LocaleModel>(
            builder: (context, localeModel, child) => DropdownButton(
              borderRadius: BorderRadius.circular(24.0),
              value: localeModel.locale.languageCode,
              items: [
                DropdownMenuItem(
                  value: "en",
                  child: Text('🇺🇸 ${locale.english}'),
                ),
                DropdownMenuItem(
                  value: "es",
                  child: Text('🇪🇸 ${locale.spanish}'),
                ),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  localeModel.set(Locale(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget PwdChange(AppLocalizations locale) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, ChangePassword.id),
        child: SettingCard(
          content: Text(
            locale.change_pwd.toProperCase(),
            style: AppStyles.settingTextStyle,
          ),
        ));
  }

  Widget LogOut(AppLocalizations locale) {
    return GestureDetector(
        onTap: () => userLogOut(),
        child: SettingCard(
          content: Text(
            locale.log_out.toProperCase(),
            style: AppStyles.settingTextStyle.copyWith(color: Colors.red),
          ),
        ));
  }

  Widget _SectionSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
          width: 1,
          height: 44,
          decoration: const BoxDecoration(color: AppColors.darkerGray)),
    );
  }

  Widget _InfoSection(String main, String sub) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          main,
          style:
              AppStyles.subSmallTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          sub,
          style: AppStyles.settingTextStyle,
        ),
      ],
    );
  }
}
