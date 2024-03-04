import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/notifiers/saved_products_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/coverages_list_view.dart';
import 'package:provider/provider.dart';
import '../../../models/producto.dart';
import '../../../models/usuario.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedCoverages extends StatefulWidget {
  const SavedCoverages({super.key});
  static const String id = 'saved_coverages';

  @override
  State<SavedCoverages> createState() => _SavedCoveragesState();
}

class _SavedCoveragesState extends State<SavedCoverages> {
  List<Producto> savedProducts = [];
  List<Cobertura> productCoverages = [];
  late Usuario currentUser;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchSavedProducts(int userID) async {
    try {
      if (mounted) {
        List<Producto>?  response = await ApiService.getSavedProductsbyUserID(userID);
        if (response != null)
          setState(() => savedProducts = response);
          final savedProductProvider = Provider.of<SavedProductModel>(context, listen: true);
          savedProductProvider.clear();
          savedProductProvider.addSavedProducts(response);
      }
    } catch (ex) {
      print("Error fetching saved products $ex");
    }
  }

  Future<void> _fetchCoverageByProductPlan(int planID, int productID) async {
    try {
      if (mounted) {
        var response = await ApiService.getCoveragesbyPlanProduct(planID, productID);
        if (response != null) {
          setState(() => productCoverages.add(response));
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> _fetchData() async{
    final userProvider = Provider.of<UserInfoModel>(context, listen: false);
    await _fetchSavedProducts(userProvider.currentUser!.idUsuario);

    if (savedProducts.isNotEmpty){
     await fetchProductCoverages();
    }
  }

  Future<void> fetchProductCoverages() async{
    for (Producto product in savedProducts){
      _fetchCoverageByProductPlan(Provider.of<UserInfoModel>(context, listen: false).selectedPlanID!, product.idProducto);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).saved_products,
      ),
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: productCoverages.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                productCoverages.isEmpty ?
                    Center(child: Text('No Saved Products to Show'))
                :
                CoveragesListView(coverages: productCoverages,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
