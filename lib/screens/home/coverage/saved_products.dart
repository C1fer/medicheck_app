import 'package:flutter/material.dart';
import 'package:medicheck/models/notifiers/saved_products_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/widgets/cards/product_card_med.dart';
import 'package:provider/provider.dart';
import '../../../models/producto.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../widgets/misc/data_loading_indicator.dart';


class SavedProducts extends StatefulWidget {
  const SavedProducts({super.key});
  static const String id = 'saved_products';

  @override
  State<SavedProducts> createState() => _SavedProductsState();
}

class _SavedProductsState extends State<SavedProducts> {
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchSavedProducts(int userID) async {
    ProductoResponse? response = await ApiService.getSavedProducts(userID: userID, pageSize: 1000);
    if (response != null) {
      final savedProductsProvider = context.read<SavedProductModel>();
      savedProductsProvider.replaceItems(response.data);
    }
  }

  Future<void> _fetchData() async {
    if (mounted) {
      final userID = context.read<UserInfoModel>().currentUserID!;
      await _fetchSavedProducts(userID);
    }
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
                  builder: (context, planModel, _) => Column(
                        mainAxisAlignment: planModel.savedProducts.isEmpty
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          planModel.savedProducts.isEmpty
                              ? const DataLoadingIndicator()
                              : SavedProductsGridView(context, planModel.savedProducts)
                        ],
                      ))),
        ),
      ),
    );
  }

  Widget SavedProductsGridView(BuildContext context, List<Producto> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Example: 2 columns
        crossAxisSpacing: 8, // Add spacing between columns
        mainAxisSpacing: 8, // Add spacing between rows
      ),
      itemCount: products.length,
      itemBuilder: (context, idx) => ProductCard(
        product: products[idx],
      ),
      shrinkWrap: true,
    );
  }
}
