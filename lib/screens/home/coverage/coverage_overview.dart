// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medicheck/models/misc/mock_data.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/notifiers/product_coverage_notifier.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:medicheck/screens/home/establishments/nearby_centers.dart';
import 'package:medicheck/utils/location_service.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/misc/skeletons/widget_skeleton_list.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:medicheck/widgets/popups/snackbar/show_snackbar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

class CoverageOverview extends StatefulWidget {
  const CoverageOverview({super.key});

  static const String id = 'coverages_overview';

  @override
  State<CoverageOverview> createState() => _CoverageOverviewState();
}

class _CoverageOverviewState extends State<CoverageOverview> {
  bool? isProductSaved;
  late Producto product;

  void onSavedIconTap() {
    final int userID = context.read<UserInfoModel>().currentUserID!;
    if (isProductSaved != null) {
      isProductSaved! ? _deleteSavedProduct(userID) : _postSavedProduct(userID);
    }
  }

  Future<void> _postSavedProduct(int userID) async {
    setState(() => isProductSaved = !isProductSaved!); // Update saved icon
    final bool response =
        await ApiService.postSavedProduct(userID, product.idProducto);
    if (response) {
      context.read<SavedProductModel>().deleteSavedProduct(product);
    } else {
      // Revert saved icon as fallback
      setState(() => isProductSaved = !isProductSaved!);
      // Show snackbar error
      final String errorMsg = context.read<AppLocalizations>().server_error;
      showSnackBar(context, errorMsg, MessageType.ERROR);
    }
  }

  Future<void> _deleteSavedProduct(int userID) async {
    setState(() => isProductSaved = !isProductSaved!); // Update saved icon
    final bool response =
        await ApiService.deleteSavedProduct(userID, product.idProducto);
    if (response) {
      context.read<SavedProductModel>().addSavedProduct(product);
    } else {
      // Revert saved icon as fallback
      setState(() => isProductSaved = !isProductSaved!);
      // Show snackbar error
      final String errorMsg = context.read<AppLocalizations>().server_error;
      showSnackBar(context, errorMsg, MessageType.ERROR);
    }
  }

  Future<bool> _isProductSaved() async {
    if (!mounted) return false; // Exit if not mounte

    final savedProductProvider = context.read<SavedProductModel>();
    List<int> savedProductIDs = savedProductProvider.savedProductIDs;

    if (savedProductIDs.isEmpty) {
      int? userID = context.read<UserInfoModel>().currentUserID;
      final ProductoResponse? response =
          await ApiService.getSavedProducts(userID: userID!);
      if (response != null) {
        savedProductProvider.addSavedProducts(response.data);
      }
    }

    setState(() {
      isProductSaved = savedProductProvider.isProductInList(product.idProducto);
    });

    return isProductSaved!;
  }

  Future<bool> _getProductCoverages() async {
    int selectedPlanID = context.read<PlanModel>().selectedPlanID!;
    CoberturaResponse? response = await ApiService.getCoveragesAdvanced(
        selectedPlanID,
        productID: product.idProducto,
        pageSize: 1000);
    if (response != null && response.data.isNotEmpty) {
      context.read<ProductCoveragesModel>().replaceAll(response.data);
      return true;
    }
    return Future.error("");
  }

  Future<void> onNearbyCentersPressed() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (locationEnabled) {
      Navigator.pushNamed(context, NearbyCenters.id);
    } else {
      //TODO MESSAGE
      await Geolocator.openLocationSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sentProduct =
          ModalRoute.of(context)!.settings.arguments as Producto;
      setState(() => product = sentProduct);
    });
  }

  // Future<bool> showLocationDisabledSheet() async{
  //   await showMaterialModalBottomSheet(context: context, builder: () => SimpleDialog())
  // }

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
                    ProductCoverages(context, locale)
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

  Widget SaveProductIcon() {
    return GestureDetector(
      onTap: () => isProductSaved != null ? onSavedIconTap : null,
      child: SizedBox(
        height: 40,
        width: 40,
        child: isProductSaved != null && isProductSaved!
            ? SvgPicture.asset('assets/icons/heart-full.svg')
            : SvgPicture.asset('assets/icons/heart-outlined.svg'),
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
        FutureBuilder(
            future: _isProductSaved(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return SaveProductIcon();
              } else {
                return const Skeletonizer.zone(
                    child: Bone.iconButton(
                  size: 40,
                ));
              }
            })
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
              Consumer<ProductCoveragesModel>(
                  builder: (context, coveragesModel, _) =>
                      coveragesModel.coveragesLength > 8
                          ? GestureDetector(
                        onTap: () {},
                              child: Text(
                                locale.view_all,
                                style: AppStyles.actionTextStyle
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            )
                          : const SizedBox.shrink())
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder(
              future: _getProductCoverages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Consumer<ProductCoveragesModel>(
                      builder: (context, coveragesModel, _) => Expanded(
                          child: CoveragesListView(
                              context, coveragesModel.coverages)));
                }
                if (snapshot.hasError) {
                  return Expanded(
                      child: Center(
                    child: Text(locale.no_results_shown),
                  ));
                }
                return Expanded(
                  child: WidgetSkeletonList(
                    widget: CoverageCard(
                      coverage: MockData.coverage,
                    ),
                    separator: const SizedBox(
                      height: 10,
                    ),
                    itemCount: 8,
                    ignoreContainers: false,
                  ),
                );
              }),
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
