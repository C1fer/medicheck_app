import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/screens/home/coverage/nearby_centers.dart';
import 'package:medicheck/utils/location_service.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
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
      setState(() => isSaved = !isSaved!); // Update saved icon
      final bool response = await ApiService.deleteSavedProduct(
          userProvider.currentUser!.idUsuario, product.idProducto);
      if (response) {
        savedProductProvider.deleteSavedProduct(product);
      } else {
        setState(() => isSaved = !isSaved!); // Revert saved icon as fallback
      }
    } else {
      setState(() => isSaved = !isSaved!); // Update saved icon
      final bool response = await ApiService.postSavedProduct(
          userProvider.currentUser!.idUsuario, product.idProducto);
      if (response) {
        savedProductProvider.addSavedProduct(product);
      } else {
        setState(() => isSaved = !isSaved!); // Revert saved icon as fallback
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

  Future<void> onNearbyCentersPressed() async{
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if(locationEnabled) {
      Navigator.pushNamed(context, NearbyCenters.id);
    }
    else{
      await Geolocator.openLocationSettings();
    }
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
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.coverage_details,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductIcon(),
                    const SizedBox(
                      height: 35.0,
                    ),
                    ProductDetails(context),
                    const SizedBox(
                      height: 14.0,
                    ),
                    const SizedBox(height: 10.0),
                    productCoverages != null &&
                            productCoverages!.data.isNotEmpty
                        ? ProductCoverages(context, locale)
                        : const Expanded(
                            child: Center(child: DataLoadingIndicator()))
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              FilledButton(
                onPressed: () => onNearbyCentersPressed(),
                child: Text(locale.near_centers),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ProductIcon() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: 100,
        height: 100,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget ProductDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.nombre.toProperCaseData(),
                style: AppStyles.sectionTextStyle.copyWith(fontSize: 24.0),
              ),
              const SizedBox(
                height: 6,
              ),
              FeatureCard(
                  msg: product.idTipoProductoNavigation!.nombre
                      .toProperCaseData()),
            ],
          ),
        ),
        if (isSaved != null)
          GestureDetector(
            onTap: () => _saveProduct(product),
            child: SizedBox(
              height: 40,
              width: 40,
              child: isSaved!
                  ? SvgPicture.asset('assets/icons/heart-full.svg')
                  : SvgPicture.asset('assets/icons/heart-outlined.svg'),
            ),
          )
      ],
    );
  }

  Widget ProductCoverages(BuildContext context, AppLocalizations locale) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locale.product_coverages,
                style: AppStyles.sectionTextStyle.copyWith(fontSize: 20),
              ),
              GestureDetector(
                child: Text(
                  locale.view_all,
                  style: AppStyles.actionTextStyle
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: CoveragesListView(
              context,
              productCoverages!.data,
            ),
          ),
        ],
      ),
    );
  }

  Widget CoveragesListView(BuildContext context, List<Cobertura> coverages) {
    return ListView.separated(
      itemBuilder: (context, index) => CoverageCard(
        coverage: coverages[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      itemCount: coverages.length >= 8 ? 8 : coverages.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }
}
