import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_styles.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../utils/jwt_service.dart';
import '../../../models/usuario.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../models/usuario.dart';
import '../../../models/locale.dart';
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

  void changeLocale() {}

  @override
  Widget build(BuildContext context) {
    final currentUser = ModalRoute.of(context)!.settings.arguments as Usuario;
    var selectedLocale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).profile_info_heading,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => userLogOut(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1.25, color: Color(0xFFE8F3F1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).log_out,
                      style: AppStyles.headingTextStyle.copyWith(
                          fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1.25, color: Color(0xFFE8F3F1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).change_lang,
                        style: AppStyles.headingTextStyle.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 15.0),
                      ),
                      Consumer<LocaleModel>(
                        builder: (context, localeModel, child) =>
                            DropdownButton(
                          value: selectedLocale,
                          items: [
                            DropdownMenuItem(
                              child: Text(AppLocalizations.of(context).english),
                              value: "en",
                            ),
                            DropdownMenuItem(
                              child: Text(AppLocalizations.of(context).spanish),
                              value: "es",
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
