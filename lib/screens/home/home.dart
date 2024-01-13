import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import '../../models/usuario.dart';
import '../../utils/jwt_service.dart';
import '../../widgets/cards/menu_action_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Usuario? currentUser;
  List<Cobertura> recentSearches = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCoverages();
  }

  void _fetchData() async {
    //JWT fetch
    //var _userInfo = await JWTService.decodeJWT();
    // API Fetch
    // await ApiService.getUserById(_userInfo!['IdUsuario'])
    //     .then((value) => setState(() => currentUser = value));
  }

  void _fetchCoverages() async{
    try{
      List<Cobertura> coverages = await ApiService.getCoverages();
      setState(() => recentSearches = coverages);
      print(recentSearches);
    }
    catch(except){
      print(except);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).main_menu_heading,
              style: AppStyles.headingTextStyle,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Container(
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MenuActionCard(
                    title: AppLocalizations.of(context).coverage,
                    iconPath: 'assets/icons/pharmacy.svg',
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
                    iconPath: 'assets/icons/heart.svg',
                    route: '')
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
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppLocalizations.of(context).view_all,
                    style: AppStyles.actionTextStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => CoverageCard(coverage: recentSearches[index]),
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemCount: recentSearches.length,
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
