import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/incidente.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import '../../models/enums.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class IncidentCard extends StatelessWidget {
  const IncidentCard({super.key, required this.incident, required this.onTap});

  final Incidente incident;
  final void Function() onTap;
  
  /*Color setStatusCardColor(){
    switch(incident.estado){
      case 'ABIERTO':
        return AppColors.jadeGreen;
      case ''
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center ,
              children: [
                Text(
                  incident.establecimientoNavigation.nombre!,
                  style: AppStyles.coverageCardCategoryTextStyle,
                ),
                SizedBox(width: 6,),
                Text(
                  incident.productoNavigation.nombre,
                  style: AppStyles.coverageCardCategoryTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
             incident.descripcion,
              style: AppStyles.coverageCardHeadingTextStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
