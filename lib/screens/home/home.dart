import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/screens/home/coverage/coverage_search.dart';
import 'package:medicheck/screens/home/coverage/saved_coverages.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/screens/home/settings.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/cached_coverages.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:provider/provider.dart';
import '../../models/plan.dart';
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
  List<Cobertura> planCoverages = [];
  List<Cobertura> newCoverages = [];
  List<Plan> userPlans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  Future<void> _fetchUserPlans(int userID) async {
    var response = await ApiService.getPlansbyUserID(userID);
    if (response.isNotEmpty) setState(() => userPlans = response);
    Provider.of<UserInfoModel>(context, listen: false)
        .setCurrentPlan(response.first);
  }

  Future<void> _fetchCoverages(int planID) async {
    List<Cobertura> response = await ApiService.getCoveragesAdvanced(planID);
    if (response.isNotEmpty)
      setState(() => planCoverages = response);

      response.sort((Cobertura a, Cobertura b) => b.fechaRegistro.compareTo(a.fechaRegistro));
      setState(() => newCoverages = response );
  }

  Future<void> _fetchData() async {
    final userProvider = Provider.of<UserInfoModel>(context, listen: false);
    if (userPlans.isEmpty)
      await _fetchUserPlans(userProvider.currentUser!.idUsuario);

    int? planID = userProvider.selectedPlanID;
    if (planID != null) await _fetchCoverages(planID);
  }

  void _changeSelectedPlan(String newPlanID) async{
    final userProvider = Provider.of<UserInfoModel>(context, listen: false);
    await userProvider.setCurrentPlan(
        userPlans.firstWhere((Plan plan) =>
        plan.idPlan.toString() == newPlanID));
    _fetchCoverages(userProvider.selectedPlanID!.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoModel>(
      builder: (context, user, child) => Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
                    child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 9,
                      child: Consumer<UserInfoModel>(
                          builder: (context, user, __) => Text(
                                '${AppLocalizations.of(context).welcome_msg}, ${user.currentUser!.nombre!.split(' ').first}',
                                style: AppStyles.headingTextStyle,
                                softWrap: true,
                              )),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, SettingsPage.id),
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
                  ],
                ),
                if (userPlans.length > 1)
                  const SizedBox(height: 6.0,),
                  Consumer<UserInfoModel>(
                    builder: (context, userInfo, _) => CustomDropdownButton(
                        value: userInfo.selectedPlanID.toString(),
                        onChanged: (newPlanID) => _changeSelectedPlan(newPlanID!),
                        entries: userPlans
                            .map((Plan plan) => DropdownMenuItem(
                                  value: plan.idPlan.toString(),
                                  child: Text(plan.descripcion),
                                ))
                            .toList()),
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
                        route: SavedCoverages.id,)
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
                  child: CoveragesListView(coverages: newCoverages),
                ),
              ],
            ),
                    ),
                  ),
          )),
    );
  }
}
