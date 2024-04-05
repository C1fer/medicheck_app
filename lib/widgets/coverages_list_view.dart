import 'package:flutter/material.dart';
import '../models/cobertura.dart';

import 'cards/coverage_card.dart';

class CoveragesListView extends StatelessWidget {
  const CoveragesListView({
    super.key,
    required this.coverages, this.scrollDirection = Axis.horizontal,
  });

  final List<Cobertura> coverages;
  final Axis scrollDirection;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemBuilder: (context, index) => CoverageCard(
          coverage: coverages[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        itemCount: coverages.length,
        scrollDirection: scrollDirection,
        shrinkWrap: true,
      ),
    );
  }
}
