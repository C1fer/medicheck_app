import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/screens/home/coverage/nearby_centers.dart';
import 'package:medicheck/utils/location_service.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/cobertura.dart';
import '../../../models/extensions/string_apis.dart';
import '../../../models/notifiers/saved_products_notifier.dart';
import '../../../models/notifiers/user_info_notifier.dart';
import '../../../models/responses/cobertura_response.dart';
import '../../../utils/api/api_service.dart';
import '../../../widgets/cards/feature_card.dart';
import '../../../models/enums.dart';
import '../../../models/producto.dart';
import '../../../models/responses/producto_response.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../styles/app_styles.dart';
import '../../../widgets/misc/data_loading_indicator.dart';

class CoverageDetailView extends StatefulWidget {
  const CoverageDetailView({super.key});

  static const String id = 'coverage_detail';

  @override
  State<CoverageDetailView> createState() => _CoverageDetailViewState();
}

class _CoverageDetailViewState extends State<CoverageDetailView> {
  bool? isSaved;
  CoberturaResponse? productCoverages;
  late Producto product;

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

  Future<void> _getProductCoverages(int productID) async {
    int selectedPlanID = context.read<PlanModel>().selectedPlanID!;
    CoberturaResponse? response = await ApiService.getCoveragesAdvanced(
        selectedPlanID,
        productID: productID,
        pageSize: 1000);
    if (response != null) {
      setState(() => productCoverages = response);
    }
  }

  void _fetchData(int productID) {
    _getProductCoverages(productID);
    _isProductSaved(productID);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final sentProduct =
          ModalRoute.of(context)!.settings.arguments as Producto;
      setState(() => product = sentProduct);
      _fetchData(product.idProducto);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: localization.coverage_details,
      ),
      body: SafeArea(
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
                          'assets/icons/pill.svg',
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
                                product.nombre.toProperCase(),
                                style: AppStyles.sectionTextStyle
                                    .copyWith(fontSize: 24.0),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              FeatureCard(
                                  msg: product.idTipoProductoNavigation!.nombre
                                      .toProperCase()),
                              /*Text(
                                product.idTipoProductoNavigation.nombre.toProperCase(),
                                style: AppStyles.actionTextStyle
                                    .copyWith(fontSize: 20.0, fontWeight: FontWeight.w600),),*/
                            ],
                          ),
                        ),
                        if (isSaved != null)
                          GestureDetector(
                            onTap: () => _saveProduct(product),
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
                    const SizedBox(height: 10.0),
                    productCoverages != null &&
                            productCoverages!.data.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.coverage,
                                style: AppStyles.sectionTextStyle
                                    .copyWith(fontSize: 20),

                              ),
                              const SizedBox(height: 8,),
                              GestureDetector(
                                child: CoveragesListView(
                                  context,
                                  productCoverages!.data,
                                ),
                                onTap: () {},
                              ),
                            ],
                          )
                        : const Center(child: DataLoadingIndicator())
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilledButton(
                onPressed: () => Navigator.pushNamed(context, NearbyCenters.id),
                child: Text(localization.near_centers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CoveragesListView(BuildContext context, List<Cobertura> coverages) {
    return ListView.separated(
      itemBuilder: (context, index) => CoverageCard(
        coverage: coverages[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 6.0),
      itemCount: coverages.length >= 4 ? 4 : coverages.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }
}
