import 'package:flutter/material.dart';
import 'package:medicheck/models/misc/mock_data.dart';
import 'package:medicheck/models/producto.dart';
import 'package:medicheck/models/responses/cobertura_response.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/models/tipo_producto.dart';
import 'package:medicheck/widgets/cards/product_card_sm.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:medicheck/widgets/misc/search/search_row.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/product_filter_dialog.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../models/cobertura.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/cards/product_card_med.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/api/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:convert';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});
  static const String id = "product_search";

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final _productController = TextEditingController();
  final PagingController<int, Producto> _productsPagingController =
      PagingController(firstPageKey: 1);
  List<TipoProducto> productTypes = [];

  String? _typeID;
  String _category = "ALL";

  @override
  void initState() {
    _productsPagingController.addPageRequestListener((pageKey) => searchProducts());
    context.read<PlanModel>().addListener(() => _productsPagingController.refresh());
    fetchTypes();
    super.initState();
  }

  @override
  void dispose() {
    _productsPagingController.dispose();
    _productController.dispose();
    super.dispose();
  }

  Future<void> fetchTypes() async {
    final List<TipoProducto> response = await ApiService.getProductType();
    setState(() => productTypes = response);
  }

  Future<void> searchProducts() async {
    if (mounted) {
      int planID = context.read<PlanModel>().selectedPlanID!;
      ProductoResponse? response = await ApiService.getProductsAdvanced(
          name: _productController.text,
          filterCategory: _category,
          planID: planID,
          typeID: _typeID != null ? int.parse(_typeID!) : null,
          orderField: "nombre",
          orderDirection: "asc",
          pageIndex: _productsPagingController.nextPageKey ??
              _productsPagingController.firstPageKey);

      if (response != null) {
        if (response.hasNextPage) {
          _productsPagingController.appendPage(
              response.data, response.pageNumber + 1);
        } else {
          _productsPagingController.appendLastPage(response.data);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.search_screen_title,
        canGoBack: false,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SearchBarWithFilter(
                    searchController: _productController,
                    hintText: locale.type_here,
                    onChanged: (String? val) =>
                        _productsPagingController.refresh(),
                    filterDialog: ProductFilterDialog(
                        types: productTypes,
                        typeID: _typeID,
                        categoryValue: _category,
                        onCategoryChanged: (String? val) =>
                            setState(() => _category = val!),
                        onTypeChanged: (String? val) =>
                            setState(() => _typeID = val),
                        onApplyButtonPressed: () {
                          _productsPagingController.refresh();
                          Navigator.pop(context);
                        },
                        onResetButtonPressed: () {
                          setState(() {
                            _typeID = null;
                            _category = "ALL";
                          });
                        })),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Expanded(
                      child: PagedListView.separated(
                    pagingController: _productsPagingController,
                    builderDelegate: PagedChildBuilderDelegate<Producto>(
                      itemBuilder: (context, item, index) =>
                          ProductCardSmall(product: item),
                      noItemsFoundIndicatorBuilder: (context) =>
                          Center(child: Text(locale.no_results_shown)),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const DataLoadingIndicator(),
                      newPageProgressIndicatorBuilder: (context) =>
                          const DataLoadingIndicator(),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    scrollDirection: Axis.vertical,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
