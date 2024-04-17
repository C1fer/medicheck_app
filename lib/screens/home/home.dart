import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/misc/mock_data.dart';
import 'package:medicheck/models/notifiers/localeNotifier.dart';
import 'package:medicheck/models/notifiers/recent_query_notifier.dart';
import 'package:medicheck/models/producto.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/widgets/logo/app_logo_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  // Get user search history
  Future<List<Producto>> _fetchRecentQueries() async {
    int userID = context.read<UserInfoModel>().currentUserID!;
    ProductoResponse? response =
        await ApiService.getRecentQueries(userId: userID);
    if (response != null && response.data.isNotEmpty) {
      return response.data;
    }
    return Future.error("Error fetching recent products");
  }

  Future<List<Producto>> _fetchNewProducts() async {
    ProductoResponse? response = await ApiService.getProductsAdvanced(
        planID: context.read<PlanModel>().selectedPlanID!,
        orderField: "fechaRegistro",
        orderDirection: "desc");
    if (response != null && response.data.isNotEmpty) {
      return response.data;
    }
    return Future.error("Error fetching new products");
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
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
                  height: 40.0,
                ),
                Consumer<ViewedCoverageModel>(
                  builder: (context, viewed, _) => FutureBuilder(
                      future: _fetchRecentQueries(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ViewedProducts(locale, snapshot.data));
                        } else if (snapshot.hasError) {
                          return const SizedBox.shrink();
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Skeletonizer(
                                child: NewProducts(
                                    locale, List.filled(3, MockData.product))),
                          );
                        }
                      }),
                ),
                Consumer<PlanModel>(
                    builder: (context, plan, _) => FutureBuilder(
                        future: _fetchNewProducts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return NewProducts(locale, snapshot.data);
                          } else if (snapshot.hasError) {
                            return const SizedBox.shrink();
                          } else {
                            return Skeletonizer(
                                child: NewProducts(
                                    locale, List.filled(3, MockData.product)));
                          }
                        })),
              ]),
        ),
      )),
    );
  }

  Widget CTABanner() {
    //final locale = context.read<LocaleModel>();
    return Container(
      constraints: const BoxConstraints(maxHeight: 170),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.lightJade),
      child: Padding(
        padding: const EdgeInsets.only(left: 26, top: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
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
                    padding: EdgeInsets.only(right: 24.0),
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

  Widget ViewedProducts(AppLocalizations locale, List<Producto> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.recent,
          style: AppStyles.sectionTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ProductsListView(products: products),
        ),
      ],
    );
  }

  Widget NewProducts(AppLocalizations locale, List<Producto> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.new_products,
          style: AppStyles.sectionTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: ProductsListView(products: products),
        ),
      ],
    );
  }
}
