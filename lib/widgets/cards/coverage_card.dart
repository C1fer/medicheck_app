import 'package:flutter/material.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';

class CoverageCard extends StatelessWidget {
  const CoverageCard({super.key, required this.coverage});

  final Cobertura coverage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, CoverageDetailView.id, arguments: coverage),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: ShapeDecoration(
          color: Colors.yellow,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
            ),
            Text(
              coverage.idProductoNavigation.nombre,
              style: AppStyles.coverageCardTextStyle,
            ),
            const SizedBox(height: 4.0,),
            Text(
              coverage.idProductoNavigation.categoria,
              style: AppStyles.subSmallTextStyle.copyWith(fontSize: 9.0),
            ),
            const SizedBox(height: 10.0,),
            FeatureCard(msg: '${coverage.porcentaje} %')
          ],
        ),
      ),
    );
  }
}

