import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/cobertura_grupo.dart';
import 'package:medicheck/models/notifiers/product_coverage_notifier.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/widgets/cards/coverage_card.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../models/cobertura.dart';
import '../../../widgets/misc/custom_appbar.dart';

class CoverageDetails extends StatefulWidget {
  const CoverageDetails({super.key});

  static const String id = "coverage_details";

  @override
  State<CoverageDetails> createState() => _CoverageDetailsState();
}

class _CoverageDetailsState extends State<CoverageDetails> {
  Future<List<GrupoCobertura>> _fetchGroups() async {
    final List<GrupoCobertura> groups = await ApiService.getCoverageGroups();
    if (groups.isNotEmpty) {
      return groups;
    }
    return Future.error("");
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.coverage_details,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FutureBuilder<List<GrupoCobertura>>(
            future: _fetchGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ExpansionPanelList(
                    children: _buildPanels(context, snapshot.data!),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error");
                }
              }
              return const DataLoadingIndicator();
            },
          ),
        ),
      ),
    );
  }

  List<ExpansionPanel> _buildPanels(BuildContext context, List<GrupoCobertura> groups) {
    final List<ExpansionPanel> panels = [];
    final List<Cobertura> coverages = context.read<ProductCoveragesModel>().coverages;

    for (GrupoCobertura group in groups) {
      final List<Cobertura> _coverages = coverages
          .where((c) => c.idSubGrupoNavigation.idGrupoNavigation.id == group.id)
          .toList();
      if (_coverages.isNotEmpty){
        panels.add(GroupCoverages(group, _coverages));
      }

    }
    return panels;
  }

  ExpansionPanel GroupCoverages(GrupoCobertura group, List<Cobertura> groupCoverages) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: false,
      headerBuilder: (context, isOpen) =>  Text(group.nombre),
      // body:  SizedBox(
      //   height: 50,
      //   child: ListView.separated(
      //       itemBuilder: (context, idx) =>
      //           CoverageCard(coverage: groupCoverages[idx]),
      //       separatorBuilder: (context, _) => const SizedBox(
      //         height: 10,
      //       ),
      //       itemCount: groupCoverages.length),
      // )
      body: Text(groupCoverages.first.idProductoNavigation.nombre)
    );
  }
}
