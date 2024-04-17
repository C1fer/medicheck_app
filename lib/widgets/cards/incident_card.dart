import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/incidente.dart';
import '../../models/cobertura.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import '../../models/enums.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class IncidentCard extends StatelessWidget {
  const IncidentCard({super.key, required this.incident});

  final Incidente incident;
  
  Color setStatusCardColor(){
    switch(incident.estado){
      case 'ABIERTO':
        return AppColors.lightRed;
      case 'EN_REVISION':
        return Colors.orangeAccent;
      case 'CERRADO':
        return AppColors.jadeGreen;
      default:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center ,
            children: [
             Expanded(
               flex: 7,
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.establecimientoNavigation.nombre.toProperCaseData(),
                      style: AppStyles.coverageCardCategoryTextStyle,
                    ),
                    const SizedBox(height: 4,),
                    Text(
                      incident.productoNavigation.nombre.toProperCaseData(),
                      style: AppStyles.coverageCardCategoryTextStyle,
                    ),
                  ],
                ),
             ),
              const SizedBox(width: 10,),
              FeatureCard(msg: incident.estado.toProperCase(), color: setStatusCardColor(),)
            ],
          ),
          const SizedBox(height: 10,),
          Text(
            incident.descripcion,
            style: AppStyles.coverageCardHeadingTextStyle,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

}
