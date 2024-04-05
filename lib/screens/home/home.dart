import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/notifiers/localeNotifier.dart';
import 'package:medicheck/models/notifiers/recent_query_notifier.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/responses/cobertura_response.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../models/responses/plan_response.dart';
import '../../screens/home/coverage/coverage_search.dart';
import '../../screens/home/coverage/saved_products.dart';
import '../../screens/home/establishments/establishments_list.dart';
import '../../screens/home/incidents/incident_reports.dart';
import '../../screens/home/settings/settings.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import '../../utils/api/api_service.dart';
import '../../models/notifiers/plan_notifier.dart';
import '../../widgets/cards/menu_action_card.dart';
import '../../widgets/coverages_list_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CoberturaResponse? recentlyAddedCoverages;
  CoberturaResponse? recentlyViewedCoverages;

  @override
  void initState() {
    // Define listeners for plan and recently viewed coverage
    Provider.of<PlanModel>(context, listen: false)
        .addListener(_fetchData);
    Provider.of<ViewedCoverageModel>(context, listen: false)
        .addListener(_fetchData);

    _fetchData();
    super.initState();
  }

  // Get affiliate plans
  Future<bool> _fetchUserPlans(int userID) async {
    final PlanResponse? response = await ApiService.getPlansbyUserID(userID);

    if (response != null) {
      final planProvider = context.read<PlanModel>();
      await planProvider.addPlans(response.data);
      return true;
    }
    return false;
  }

  // Get recently added coverages
  Future<void> _fetchNewCoverages(int selectedPlanID) async {
    CoberturaResponse? response = await ApiService.getCoveragesAdvanced(
        planID: selectedPlanID,
        orderField: "fecha_registro",
        orderDirection: "desc");
    setState(() => recentlyAddedCoverages = response);
  }

  // Get user search history
  Future<void> _fetchRecentQueries(int selectedPlanID, int userID) async {
    CoberturaResponse? response = await ApiService.getRecentQueries(
        userId: userID, planId: selectedPlanID);
    setState(() => recentlyViewedCoverages = response);
  }

  // Fetch to be executed on initState
  Future<void> _fetchData() async {
    int? userID = context.read<UserInfoModel>().currentUserID;

    if (userID != null) {
      final planProvider = context.read<PlanModel>();
      if (planProvider.plans.isEmpty) {
        bool response = await _fetchUserPlans(userID);
      }
      int selectedPlanID = planProvider.selectedPlanID!;
      await _fetchNewCoverages(selectedPlanID);
      await _fetchRecentQueries(selectedPlanID, userID);
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
              mainAxisSize: MainAxisSize.min,
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
                        route: IncidentReports.id),
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
                CTABanner(),
                const SizedBox(
                  height: 35.0,
                ),
                if (recentlyViewedCoverages != null &&
                    recentlyViewedCoverages!.data.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).recent_viewed,
                        style: AppStyles.sectionTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: CoveragesListView(
                            coverages: recentlyViewedCoverages?.data != null
                                ? recentlyViewedCoverages!.data
                                : []),
                      ),
                    ],
                  ),
                Text(
                  AppLocalizations.of(context).recently_added,
                  style: AppStyles.sectionTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: CoveragesListView(
                      coverages: recentlyAddedCoverages?.data != null
                          ? recentlyAddedCoverages!.data
                          : []),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget CTABanner() {
    //final locale = context.read<LocaleModel>();
    return Container(
      constraints: BoxConstraints(maxHeight: 170),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.lightJade),
      child: Padding(
        padding: EdgeInsets.only(left: 26, top: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "En MediCheck cuidamos tu salud",
                    style: AppStyles.sectionTextStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child:
                        FilledButton(onPressed: null, child: Text("Leer más")),
                  )
                ],
              ),
            ),
            Expanded(
              child: SvgPicture.asset(
                'assets/icons/question-circle.svg',
                color: Colors.black.withOpacity(0.15),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container PlaceHolderSearchBar() {
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
            style:
                const TextStyle(color: AppColors.deepLightGray, fontSize: 12),
          )
        ]),
      ),
    );
  }
}
