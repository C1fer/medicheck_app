import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:medicheck/styles/app_colors.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import '../../models/enums.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class CoverageCard extends StatelessWidget {
  const CoverageCard({super.key, required this.coverage});

  final Cobertura coverage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, CoverageDetailView.id,
          arguments: coverage),
      child: Container(
        height: 173,
        width: 118,
        padding: const EdgeInsets.all(12.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 54,
              height: 54,
              child: SvgPicture.asset(Constants.productTypeIcons[coverage.idProductoNavigation.tipo]!, fit: BoxFit.fitHeight,),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: Text(
                coverage.idProductoNavigation.nombre,
                style: AppStyles.coverageCardHeadingTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              toBeginningOfSentenceCase(coverage.idProductoNavigation.tipo)!,
              style: AppStyles.coverageCardCategoryTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
              child: FeatureCard(msg: '${coverage.porcentaje} %'),
            )
          ],
        ),
      ),
    );
  }
}
