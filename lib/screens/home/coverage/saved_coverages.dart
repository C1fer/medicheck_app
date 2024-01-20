import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
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
  List<Cobertura> coverages = [];

  @override
  void initState() {
    super.initState();
    _getSavedCoverages();
  }

  void _getSavedCoverages() async {
    try {
      if (mounted) {
        await ApiService.getCoverages()
            .then((value) => setState(() => coverages = value));
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).saved_products,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  CoverageCard(coverage: coverages[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: coverages.length),
        ),
      ),
    );
  }
}
