import 'package:flutter/material.dart';
import 'package:medicheck/models/responses/cobertura_response.dart';
import 'package:medicheck/widgets/misc/search/search_row.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/product_filter_dialog.dart';
import 'package:provider/provider.dart';
import '../../../models/cobertura.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/cards/coverage_card_sm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/api/api_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CoverageSearch extends StatefulWidget {
  const CoverageSearch({super.key});
  static const String id = "coverage_search";

  @override
  State<CoverageSearch> createState() => _CoverageSearchState();
}

class _CoverageSearchState extends State<CoverageSearch> {
  final _coverageController = TextEditingController();
  final PagingController<int, Cobertura> _coveragesPagingController =
      PagingController(firstPageKey: 1);

  String? _typeVal;
  String? _categoryVal;

  Future<void> searchProductCoverages() async {
    if (mounted) {
      debugPrint("in");
      int? planID = context.read<PlanModel>().selectedPlanID;
      CoberturaResponse? response = await ApiService.getCoveragesAdvanced(
          planID: planID,
          name: _coverageController.text,
          type: _typeVal,
          category: _categoryVal,
          pageIndex: _coveragesPagingController.nextPageKey ??
              _coveragesPagingController.firstPageKey);

      if (response != null) {
        if (response.hasNextPage) {
          _coveragesPagingController.appendPage(
              response.data, response.pageNumber + 1);
        } else {
          _coveragesPagingController.appendLastPage(response.data);
        }
        _coveragesPagingController.itemList!.forEach((Cobertura element) =>
            debugPrint(element.idProductoNavigation.nombre));
      }
    }
  }

  @override
  void initState() {
    _coveragesPagingController.addPageRequestListener((pageKey) => searchProductCoverages());
    super.initState();
  }

  @override
  void dispose() {
    _coveragesPagingController.dispose();
    _coverageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: locale.search_screen_title),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 32, top: 12, bottom: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SearchBarWithFilter(
                    searchController: _coverageController,
                    hintText: locale.type_here,
                    onChanged: (String? val) =>
                        _coveragesPagingController.refresh(),
                    filterDialog: ProductFilterDialog(
                        typeValue: _typeVal,
                        categoryValue: _categoryVal,
                        onCategoryChanged: (String? val) =>
                            setState(() => _categoryVal = val),
                        onTypeChanged: (String? val) =>
                            setState(() => _typeVal = val),
                        onButtonPressed: () async {
                          searchProductCoverages();
                          Navigator.pop(context);
                        })),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Expanded(
                  child: PagedListView.separated(
                pagingController: _coveragesPagingController,
                builderDelegate: PagedChildBuilderDelegate<Cobertura>(
                    itemBuilder: (context, item, index) =>
                        CoverageCardSmall(coverage: item),
                    noItemsFoundIndicatorBuilder: (context) =>
                        Center(child: Text(locale.no_results_shown))),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 40),
                scrollDirection: Axis.vertical,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
