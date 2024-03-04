import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../../models/user_info_notifier.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/cards/coverage_card_sm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _coverageController.addListener(() => _searchProductCoverages());
    _searchProductCoverages();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _coverageController.dispose();
  }

  void _searchProductCoverages() async {
    print("Name: ${_coverageController.text}\ntype:$_typeVal\ncategory:$_categoryVal");
    int? planID =
        Provider.of<UserInfoModel>(context, listen: false).selectedPlanID;
    if (mounted) {
      await ApiService.getCoveragesAdvanced(planID!,
              name: _coverageController.text,
              type: _typeVal,
              category: _categoryVal)
          .then((value) => setState(() => coverages = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.search_screen_title,
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
                        hintText: locale.search_product,
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
                          context, AdvancedSearchDropdown(context),
                          dismissible: true),
                      child: const Icon(
                        Icons.filter_alt,
                        color: AppColors.lightGray,
                      ),
                    ))
                  ],
                ),
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

  Widget AdvancedSearchDropdown(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text(
          locale.filter_options,
          style: AppStyles.headingTextStyle.copyWith(fontSize: 18.0),
        )),
        const SizedBox(height: 16.0),
        Text(locale.category,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        CustomDropdownButton(
            value: _categoryVal,
            isNullable: true,
            isExpanded: true,
            onChanged: (newVal) => setState(() => _categoryVal = newVal),
            entries: Constants.productCategories
                .map((String category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList()),
        const SizedBox(
          height: 16,
        ),
        Text(
          locale.type,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        CustomDropdownButton(
            value: _typeVal,
            isNullable: true,
            isExpanded: true,
            onChanged: (newVal) => setState(() => _typeVal = newVal),
            entries: Constants.productTypes
                .map((String type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList()),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: () {
                _searchProductCoverages();
                Navigator.pop(context);
              },
              child: const Text('OK')),
        )
      ],
    );
  }
}
