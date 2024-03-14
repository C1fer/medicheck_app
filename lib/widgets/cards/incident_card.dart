import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/incident.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import '../../models/enums.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class IncidentCard extends StatelessWidget {
  const IncidentCard({super.key, required this.incident, required this.onTap});

  final ReporteIncidente incident;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            const SizedBox(height: 16.0),
            Flexible(
              child: Text(
               incident.descripcion,
                style: AppStyles.coverageCardHeadingTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Text(
                  incident.establecimientoNavigation.nombre!,
                  style: AppStyles.coverageCardCategoryTextStyle,
                ),
                Text(
                  incident.productoNavigation.nombre,
                  style: AppStyles.coverageCardCategoryTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
