import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/cards/settings_card.dart';
import '../../widgets/misc/custom_appbar.dart';
import '../../../utils/jwt_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/notifiers/localeNotifier.dart';
import '../welcome/welcome.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const String id = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void userLogOut() {
    JWTService.deleteJWT();
    Navigator.pushNamed(context, Welcome.id);
  }

  @override
  Widget build(BuildContext context) {
    //final currentUser = ModalRoute.of(context)!.settings.arguments as Usuario;
    var selectedLocale = Localizations.localeOf(context).toString();
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localization.profile_info_heading,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () => userLogOut(),
                    child: SettingCard(
                      content: Text(
                        localization.log_out,
                        style: AppStyles.headingTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.red),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                SettingCard(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localization.change_lang,
                        style: AppStyles.headingTextStyle.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 15.0),
                      ),
                      Consumer<LocaleModel>(
                        builder: (context, localeModel, child) =>
                            DropdownButton(
                          value: selectedLocale,
                          items: [
                            DropdownMenuItem(
                              value: "en",
                              child: Text('🇺🇸 ${localization.english}'),
                            ),
                            DropdownMenuItem(
                              value: "es",
                              child: Text('🇪🇸 ${localization.spanish}'),
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
                ),
              ],
            )),
      ),
    );
  }
}
