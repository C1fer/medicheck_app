import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/cards/coverage_card_sm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_styles.dart';
import '../../../utils/api/api_service.dart';

class CoverageSearch extends StatefulWidget {
  const CoverageSearch({super.key});
  static const String id = "coverage_search";

  @override
  State<CoverageSearch> createState() => _CoverageSearchState();
}

class _CoverageSearchState extends State<CoverageSearch> {
  final _coverageController = TextEditingController();
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
    if (mounted && _coverageController.text!= ""){
      await ApiService.getCoveragesAdvanced(
          _coverageController.text, null, null, null)
          .then((value) => setState(() => coverages = value));
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
                padding: const EdgeInsets.fromLTRB(15.0,0,0,0),
                child: SearchBar(
                  controller: _coverageController,
                  hintText: AppLocalizations.of(context).search_product,
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Color(0xFFF9FAFB)),
                  leading: const Icon(
                    Icons.search,
                    size: 20,
                    weight: 1,
                    color: AppColors.deepLightGray,
                  ),
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(
                      TextStyle(color: AppColors.deepLightGray, fontSize: 16)),
                  side: const MaterialStatePropertyAll<BorderSide>(
                    BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                  ),
                  elevation: const MaterialStatePropertyAll<double?>(0.0),
                ),
              ),
              const SizedBox(
                height: 55.0,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      CoverageCardSmall(coverage: coverages[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 40),
                  itemCount: coverages.length,
                  scrollDirection: Axis.vertical,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
