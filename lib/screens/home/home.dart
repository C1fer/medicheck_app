import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/screens/home/coverage/coverage_search.dart';
import 'package:medicheck/screens/home/coverage/saved_coverages.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/screens/home/settings.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/cached_coverages.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import '../../models/usuario.dart';
import '../../utils/jwt_service.dart';
import '../../widgets/cards/menu_action_card.dart';
import '../../widgets/coverages_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Usuario? currentUser;
  List<Cobertura> planCoverages = [];
  List<Cobertura> recentSearches = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    //JWT fetch
    var userInfo = await JWTService.decodeJWT();

    await ApiService.getCoveragesbyUserID(userInfo!['IdUsuario'])
        .then((value) => setState(() => planCoverages = value));

    // API Fetch
    await ApiService.getUserById(userInfo!['IdUsuario'])
        .then((value) => setState(() => currentUser = value));

    // await CachedCoveragesService.get()
    //     .then((value) => setState(() => recentSearches = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24,12,24,24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, SettingsPage.id, arguments: currentUser),
                child: Container(
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(
                    'assets/icons/user-circle.svg',
                    color: AppColors.jadeGreen,
                  ),
                ),
              ),
            ),
            Text(
              AppLocalizations.of(context).main_menu_heading,
              style: AppStyles.headingTextStyle,
              softWrap: true,
            ),
            const SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, CoverageSearch.id),
              child: Container(
                alignment: Alignment.center,
                width: 324,
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Color(0xffFBFBFB)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(children: [
                    const Icon(
                      Icons.search,
                      size: 18.0,
                      weight: 0.8,
                      color: AppColors.deepLightGray,
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      AppLocalizations.of(context).search_box_placeholder,
                      style: const TextStyle(
                          color: AppColors.deepLightGray, fontSize: 12),
                    )
                  ]),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MenuActionCard(
                    title: AppLocalizations.of(context).incidents,
                    iconPath: 'assets/icons/incident.svg',
                    route: ''),
                const SizedBox(
                  width: 22.0,
                ),
                MenuActionCard(
                    title: AppLocalizations.of(context).medical_centers,
                    iconPath: 'assets/icons/hospital.svg',
                    route: EstablishmentsList.id),
                const SizedBox(
                  width: 22.0,
                ),
                MenuActionCard(
                    title: AppLocalizations.of(context).favourites,
                    iconPath: 'assets/icons/heart-outlined.svg',
                    route: SavedCoverages.id)
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).recent_coverages,
                  style: AppStyles.sectionTextStyle,
                ),
                // GestureDetector(
                //   onTap: () {},
                //   child: Text(
                //     AppLocalizations.of(context).view_all,
                //     style: AppStyles.actionTextStyle,
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: CoveragesListView(coverages: planCoverages),
            ),
            Text(
              AppLocalizations.of(context).new_coverages,
              style: AppStyles.sectionTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: CoveragesListView(coverages: planCoverages),
            ),
          ],
        ),
      ),
    ));
  }
}
