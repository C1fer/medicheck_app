import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';

class CoverageDetailView extends StatefulWidget {
  const CoverageDetailView({super.key, required this.coverageData});

  static const String id = 'coverage_detail';

  final Cobertura coverageData;

  @override
  State<CoverageDetailView> createState() => _CoverageDetailViewState();
}

class _CoverageDetailViewState extends State<CoverageDetailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(widget.coverageData.idProductoNavigation.nombre)],
    );
  }
}
