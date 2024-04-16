import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/notifiers/localeNotifier.dart';
import 'package:medicheck/models/notifiers/recent_query_notifier.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/widgets/logo/app_logo_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/responses/cobertura_response.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../models/responses/plan_response.dart';
import '../../screens/home/coverage/product_search.dart';
import '../../screens/home/coverage/saved_products.dart';
import '../../screens/home/establishments/establishments_list.dart';
import '../../screens/home/incidents/incident_reports.dart';
import '../../screens/home/settings/settings.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import '../../utils/api/api_service.dart';
import '../../models/notifiers/plan_notifier.dart';
import '../../widgets/cards/menu_action_card.dart';
import '../../widgets/logo/full_logo.dart';
import '../../widgets/products_list_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProductoResponse? recentlyAddedProducts;
  ProductoResponse? recentlyViewedProducts;

  @override
  void initState() {
    // Define listeners for plan and recently viewed coverage
    Provider.of<PlanModel>(context, listen: false).addListener(_fetchData);
    Provider.of<ViewedCoverageModel>(context, listen: false).addListener(_fetchData);

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

  // Get user search history
  Future<void> _fetchRecentQueries(int userID) async {
    ProductoResponse? response =
        await ApiService.getRecentQueries(userId: userID);
    setState(() => recentlyViewedProducts = response);
  }

  Future<void> _fetchNewProducts(int selectedPlanID) async {
    ProductoResponse? response = await ApiService.getProductsAdvanced(
        planID: selectedPlanID,
        orderField: "id_producto",
        orderDirection: "desc");
    setState(() => recentlyAddedProducts = response);
  }

  // Fetch to be executed on initState
  Future<void> _fetchData() async {
    int? userID = context.read<UserInfoModel>().currentUserID;

    if (userID != null) {
      final planProvider = context.read<PlanModel>();
      if (planProvider.plans.isEmpty) {
        await _fetchUserPlans(userID);
      }
      int selectedPlanID = planProvider.selectedPlanID!;
      await _fetchNewProducts(selectedPlanID);
      await _fetchRecentQueries(userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Consumer<UserInfoModel>(
        builder: (context, user, child) => Scaffold(
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppLogo(
                          width: 30,
                          height: 30,
                          fontSize: 26,
                          orientation: LogoOrientation.Horizontal,
                          color: AppColors.jadeGreen,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ActionsRow(locale),
                        const SizedBox(
                          height: 24.0,
                        ),
                        if (recentlyViewedProducts != null &&
                            recentlyViewedProducts!.data.isNotEmpty)
                          ViewedProducts(locale),
                        NewProducts(locale),
                      ]),
                ),
              )),
            ));
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
                    "Apoderate de tu salud con MediCheck",
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

  Widget ActionsRow(AppLocalizations locale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MenuActionCard(
            title: locale.incidents,
            iconPath: 'assets/icons/incident.svg',
            route: IncidentReports.id),
        const SizedBox(
          width: 22.0,
        ),
        MenuActionCard(
            title: locale.medical_centers,
            iconPath: 'assets/icons/hospital.svg',
            route: EstablishmentsList.id),
        const SizedBox(
          width: 22.0,
        ),
        MenuActionCard(
          title: locale.favourites,
          iconPath: 'assets/icons/heart-outlined.svg',
          route: SavedProducts.id,
        )
      ],
    );
  }

  Widget ViewedProducts(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.recent,
          style: AppStyles.sectionTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ProductsListView(
              products: recentlyViewedProducts?.data != null
                  ? recentlyViewedProducts!.data
                  : []),
        ),
      ],
    );
  }

  Widget NewProducts(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.new_products,
          style: AppStyles.sectionTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: ProductsListView(
              products: recentlyAddedProducts?.data != null
                  ? recentlyAddedProducts!.data
                  : []),
        ),
      ],
    );
  }
}
