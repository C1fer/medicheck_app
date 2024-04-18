import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/misc/mock_data.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/widgets/cards/product_card_med.dart';
import 'package:medicheck/widgets/misc/skeletons/widget_skeleton_grid.dart';
import 'package:provider/provider.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../models/producto.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedProducts extends StatefulWidget {
  const SavedProducts({super.key});
  static const String id = 'saved_products';

  @override
  State<SavedProducts> createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  final PagingController<int, Producto> _savedProductsPagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 4);

  @override
  void initState() {
    _savedProductsPagingController.addPageRequestListener((pageKey) => _fetchSavedProducts());
    super.initState();
  }

  Future<bool> _fetchSavedProducts() async {
    if (mounted) {
      final userID = context.read<UserInfoModel>().currentUserID!;
      ProductoResponse? response = await ApiService.getSavedProducts(
          userID: userID,
          pageIndex: _savedProductsPagingController.nextPageKey ??
              _savedProductsPagingController.firstPageKey);
      if (response != null) {
        if (response.hasNextPage) {
          _savedProductsPagingController.appendPage(
              response.data, response.pageNumber + 1);
        } else {
          _savedProductsPagingController.appendLastPage(response.data);
        }
        return true;
      }
    }
    return Future.error("Error fetching saved products");
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
            padding: const EdgeInsets.all(24.0),
            child: FutureBuilder(
                future: _fetchSavedProducts(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(child: SavedProductsGrid());
                  } else if (snapshot.hasError) {
                    return Expanded(
                        child: Center(child: Text(locale.no_results_shown)));
                  } else {
                    return Expanded(
                      child: WidgetSkeletonGrid(
                        widget: ProductCard(
                          product: MockData.product,
                        ),
                        itemCount: 10,
                        ignoreContainers: false,
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget SavedProductsGrid() {
    return PagedGridView(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        pagingController: _savedProductsPagingController,
        shrinkWrap: true,
        builderDelegate: PagedChildBuilderDelegate<Producto>(
            itemBuilder: (context, product, idx) =>
                ProductCard(product: product)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Example: 2 columns
          crossAxisSpacing: 8, // Add spacing between columns
          mainAxisSpacing: 8, // Add spacing between rows
        ));
  }
}
