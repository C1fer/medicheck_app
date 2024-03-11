import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura_response.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/plan_response.dart';
import 'package:medicheck/screens/home/coverage/coverage_search.dart';
import 'package:medicheck/screens/home/coverage/saved_products.dart';
import 'package:medicheck/screens/home/establishments/establishments_list.dart';
import 'package:medicheck/screens/home/settings.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:provider/provider.dart';
import '../../models/notifiers/plan_notifier.dart';
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
  CoberturaResponse? planCoverages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<PlanModel>(context, listen: false).addListener(_fetchCoverages);
    _fetchData();
  }

  Future<void> _fetchUserPlans(int userID) async {
    final PlanResponse? response = await ApiService.getPlansbyUserID(userID);

    if (response != null) {
      final planProvider = context.read<PlanModel>();
      planProvider.addPlans(response.data);
      planProvider.setCurrentPlan(response.data.first);
    }
  }

  Future<void> _fetchCoverages() async {
    int selectedPlanID = context.read<PlanModel>().selectedPlanID!;
    CoberturaResponse? response = await ApiService.getCoveragesAdvanced(selectedPlanID);
    setState(() => planCoverages = response);
  }

  Future<void> _fetchData() async {
    final userProvider = context.read<UserInfoModel>();
    final planProvider = context.read<PlanModel>();

    if (planProvider.plans.isEmpty) {
      await _fetchUserPlans(userProvider.currentUser!.idUsuario);
    }

    int? planID = planProvider.selectedPlanID;
    if (planID != null) {
      await _fetchCoverages();
    }
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
                const SizedBox(
                  height: 24.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, CoverageSearch.id),
                  child: PlaceHolderSearchBar(),
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
                      route: SavedProducts.id,
                    )
                  ],
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  AppLocalizations.of(context).recent_coverages,
                  style: AppStyles.sectionTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: CoveragesListView(
                      coverages: planCoverages?.data != null
                          ? planCoverages!.data
                          : []),
                ),
                Text(
                  AppLocalizations.of(context).new_coverages,
                  style: AppStyles.sectionTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: CoveragesListView(
                      coverages: planCoverages?.data != null
                          ? planCoverages!.data
                          : []),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Container PlaceHolderSearchBar(){
    return Container(
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
    );
  }
}
