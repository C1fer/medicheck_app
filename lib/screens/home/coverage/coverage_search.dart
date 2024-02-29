import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/dropdown/dropdown.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/cards/coverage_card_sm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/enums.dart';
import '../../../widgets/popups/dialog/custom_dialog.dart';

class CoverageSearch extends StatefulWidget {
  const CoverageSearch({super.key});
  static const String id = "coverage_search";

  @override
  State<CoverageSearch> createState() => _CoverageSearchState();
}

class _CoverageSearchState extends State<CoverageSearch> {
  final _coverageController = TextEditingController();
  // String _typeVal = Constants.productTypes.first;
  // String _categoryVal = Constants.productCategories.first;
  String? _typeVal;
  String? _categoryVal;

  List<Cobertura> coverages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _coverageController.addListener(() => _searchCoverage());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _coverageController.dispose();
  }

  void _searchCoverage() async {
    if (mounted && _coverageController.text.length > 0) {
      await ApiService.getCoveragesAdvanced(
              _coverageController.text, null, _typeVal, _categoryVal)
          .then((value) => setState(() => coverages = value));
    }

    if (_coverageController.text.length == 0) {
      coverages.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).search_screen_title,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 32, 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: SearchBar(
                        controller: _coverageController,
                        hintText: AppLocalizations.of(context).search_product,
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color(0xFFF9FAFB)),
                        leading: const Icon(
                          Icons.search,
                          size: 20,
                          weight: 1,
                          color: AppColors.deepLightGray,
                        ),
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        hintStyle: const MaterialStatePropertyAll<TextStyle>(
                            TextStyle(
                                color: AppColors.deepLightGray, fontSize: 16)),
                        side: const MaterialStatePropertyAll<BorderSide>(
                          BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                        ),
                        elevation: const MaterialStatePropertyAll<double?>(0.0),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => showCustomDialog(
                          context, AdvancedSearchDropdown(),
                          dismissible: true),
                      child: const Icon(Icons.umbrella),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 55.0,
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
                const Center(child: Text('No coverages to show'))
            ],
          ),
        ),
      ),
    );
  }

  Widget AdvancedSearchDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomDropdownButton(
            currentVal: _categoryVal ?? Constants.productCategories.first,
            onChanged: (newVal) => setState(() => _categoryVal = newVal),
            values: Constants.productCategories),
        const SizedBox(
          height: 16,
        ),
        CustomDropdownButton(
            currentVal:  _typeVal ?? Constants.productTypes.first,
            onChanged: (newVal) => setState(() => _typeVal = newVal),
            values: Constants.productTypes),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        )
      ],
    );
  }
}
