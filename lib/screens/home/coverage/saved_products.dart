import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/notifiers/saved_products_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/coverages_list_view.dart';
import 'package:provider/provider.dart';
import '../../../models/producto.dart';
import '../../../models/usuario.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/misc/search/search_row.dart';
import '../../../widgets/popups/dialog/dialogs/product_filter_dialog.dart';
import 'coverage_details.dart';

class SavedProducts extends StatefulWidget {
  const SavedProducts({super.key});
  static const String id = 'saved_products';

  @override
  State<SavedProducts> createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  final _savedProductContoller = TextEditingController();
  List<Cobertura> productCoverages = [];
  String? category;
  String? type;

  Future<void> _fetchSavedProducts(int userID) async {
    try {
      final savedProductsProvider = context.read<SavedProductModel>();
      List<Producto> savedProducts =
          await ApiService.getSavedProductsbyUserID(userID);
      savedProductsProvider.replaceItems(savedProducts);
    } catch (ex) {
      print("Error fetching saved products $ex");
    }
  }

  Future<void> _fetchData() async {
    if (mounted) {
      final userProvider = context.read<UserInfoModel>();
      final savedProductsProvider = context.read<SavedProductModel>();
      await _fetchSavedProducts(userProvider.currentUser!.idUsuario);
      await fetchProductCoverages(savedProductsProvider.savedProducts);
    }
  }

  Future<Cobertura?> _fetchCoverageByProductPlan(
      int planID, int productID) async {
    try {
      if (mounted) {
        var response =
            await ApiService.getCoveragebyPlanProduct(planID, productID);
        if (response != null) {
          return response;
        }
      }
    } catch (ex) {
      print(ex);
    }
    return null;
  }

  Future<void> fetchProductCoverages(List<Producto> savedProducts) async {
    List<Cobertura> coverages = [];
    for (Producto product in savedProducts) {
      Cobertura? productCoverage = await _fetchCoverageByProductPlan(
          context.read<UserInfoModel>().selectedPlanID!, product.idProducto);
      if (productCoverage != null) {
        coverages.add(productCoverage);
      }
    }
    setState(() => productCoverages = coverages);
  }

  Future<void> filterProducts() async {

  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.saved_products,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<SavedProductModel>(
                builder: (context, saved, _) => Column(
                  mainAxisAlignment: productCoverages.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    productCoverages.isEmpty
                        ? Center(child: Text('No Saved Products to Show'))
                        : ExistentSaveProductsLayout()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget ExistentSaveProductsLayout() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SearchBarWithFilter(
              searchController: _savedProductContoller,
              hintText: context.read<AppLocalizations>().search_product,
              onChanged: (String? val) => filterProducts(),
              filterDialog: ProductFilterDialog(
                  typeValue: type,
                  categoryValue: category,
                  onCategoryChanged: (String? val) =>
                      setState(() => category = val),
                  onTypeChanged: (String? val) => setState(() => type = val),
                  onButtonPressed: () async {
                    filterProducts();
                    Navigator.pop(context);
                  })),
        ),
        Consumer<SavedProductModel>(
          builder: (context, savedProvider, _) => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Example: 2 columns
              crossAxisSpacing: 8, // Add spacing between columns
              mainAxisSpacing: 8, // Add spacing between rows
            ),
            itemCount: productCoverages.length,
            itemBuilder: (context, idx) => CoverageCard(
              coverage: productCoverages[idx],
              onTap: () async {
                await Navigator.pushNamed(context, CoverageDetailView.id,
                    arguments: productCoverages[idx]);
                _fetchData();
              },
            ),
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
