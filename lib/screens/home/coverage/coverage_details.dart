import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicheck/screens/home/coverage/nearby_centers.dart';
import 'package:medicheck/utils/location_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/cobertura.dart';
import '../../../models/extensions/string_apis.dart';
import '../../../models/notifiers/saved_products_notifier.dart';
import '../../../models/notifiers/user_info_notifier.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/cards/feature_card.dart';
import '../../../models/enums.dart';
import '../../../models/producto.dart';
import '../../../models/responses/producto_response.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../styles/app_styles.dart';

class CoverageDetailView extends StatefulWidget {
  const CoverageDetailView({super.key});

  static const String id = 'coverage_detail';

  @override
  State<CoverageDetailView> createState() => _CoverageDetailViewState();
}

class _CoverageDetailViewState extends State<CoverageDetailView> {
  bool? isSaved;

  //TODO: Remove saved product using API
  void _saveProduct(Producto product) async {
    final userProvider = context.read<UserInfoModel>();
    final savedProductProvider = context.read<SavedProductModel>();

    if (isSaved!) {
      final bool response = await ApiService.deleteSavedProduct(
          userProvider.currentUser!.idUsuario, product.idProducto);
      if (response) {
        setState(() => isSaved = !isSaved!);
        savedProductProvider.deleteSavedProduct(product);
      }
    } else {
      final bool response = await ApiService.postSavedProduct(
          userProvider.currentUser!.idUsuario, product.idProducto);
      if (response) {
        setState(() => isSaved = !isSaved!);
        savedProductProvider.addSavedProduct(product);
      }
    }
  }

  Future<void> _isProductSaved(int productID) async {
    final savedProductProvider = context.read<SavedProductModel>();
    List<int> savedProductIDs = savedProductProvider.savedProductIDs;
    if (savedProductIDs.isNotEmpty) {
      setState(() => isSaved = savedProductProvider.isProductInList(productID));
    } else {
      int? userID = context.read<UserInfoModel>().currentUserID;
      final ProductoResponse? response =
          await ApiService.getSavedProducts(userID: userID!);
      if (response != null) {
        savedProductProvider.addSavedProducts(response.data);
        setState(
            () => isSaved = savedProductProvider.isProductInList(productID));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverage = ModalRoute.of(context)!.settings.arguments as Cobertura;
    _isProductSaved(coverage.idProducto);
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: localization.coverage_details,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 120,
                          height: 120,
                          child: SvgPicture.asset(
                            Constants.productTypeIcons[
                                coverage.idProductoNavigation.tipo]!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 75.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coverage.idProductoNavigation.nombre,
                                  style: AppStyles.sectionTextStyle
                                      .copyWith(fontSize: 30.0),
                                ),
                                const SizedBox(
                                  height: 6.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${coverage.porcentaje}% ${localization.coverage_percentage}',
                                      style: AppStyles.actionTextStyle.copyWith(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSaved != null)
                            GestureDetector(
                              onTap: () =>
                                  _saveProduct(coverage.idProductoNavigation),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: isSaved!
                                    ? SvgPicture.asset(
                                        'assets/icons/heart-full.svg')
                                    : SvgPicture.asset(
                                        'assets/icons/heart-outlined.svg'),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        localization.details,
                        style:
                            AppStyles.sectionTextStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          FeatureCard(
                              msg: coverage.idProductoNavigation.tipo
                                  .toSentenceCase()),
                          const SizedBox(
                            width: 20,
                          ),
                          if (coverage.idProductoNavigation.tipo !=
                              coverage.idProductoNavigation.categoria)
                            (FeatureCard(
                              msg: coverage.idProductoNavigation.categoria
                                  .toSentenceCase(),
                            )),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        localization.description,
                        style:
                            AppStyles.sectionTextStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 11.0),
                      Text(
                        coverage.idProductoNavigation.descripcion,
                        style: AppStyles.coverageCardCategoryTextStyle
                            .copyWith(fontSize: 18),
                      ),
                      // const SizedBox(
                      //   height: 50,
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FilledButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, NearbyCenters.id),
                  child: Text(localization.near_centers),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
