import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:medicheck/widgets/misc/search/search_row.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/product_filter_dialog.dart';
import 'package:provider/provider.dart';
import '../../../models/notifiers/user_info_notifier.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../widgets/cards/coverage_card_sm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/enums.dart';

class CoverageSearch extends StatefulWidget {
  const CoverageSearch({super.key});
  static const String id = "coverage_search";

  @override
  State<CoverageSearch> createState() => _CoverageSearchState();
}

class _CoverageSearchState extends State<CoverageSearch> {
  final _coverageController = TextEditingController();
  String? _typeVal;
  String? _categoryVal;

  List<Cobertura> coverages = [];

  @override
  void dispose() {
    super.dispose();
    _coverageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchProductCoverages();
  }

  Future<void> _searchProductCoverages() async {
    int? planID = context.read<UserInfoModel>().selectedPlanID;
    if (mounted) {
      List<Cobertura> foundCoverages = await ApiService.getCoveragesAdvanced(
          planID!,
          name: _coverageController.text,
          type: _typeVal,
          category: _categoryVal);

      setState(() => coverages = foundCoverages);
    }
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
                    hintText: locale.search_product,
                    onChanged: (String? val) => _searchProductCoverages(),
                    filterDialog: ProductFilterDialog(
                        typeValue: _typeVal,
                        categoryValue: _categoryVal,
                        onCategoryChanged: (String? val) =>
                            setState(() => _categoryVal = val),
                        onTypeChanged: (String? val) =>
                            setState(() => _typeVal = val),
                        onButtonPressed: () async {
                          _searchProductCoverages();
                          Navigator.pop(context);
                        })),
              ),
              const SizedBox(
                height: 40.0,
              ),
              if (coverages.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        CoverageCardSmall(coverage: coverages[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 40),
                    itemCount: coverages.length,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              if (coverages.isEmpty)
                Center(child: Text(locale.no_products_to_show))
            ],
          ),
        ),
      ),
    );
  }
}
