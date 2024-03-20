import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import '../../models/establecimiento.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class EstablishmentCard extends StatelessWidget {
  const EstablishmentCard({super.key, required this.establecimiento});
  final Establecimiento establecimiento;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 72,
              height: 72,
              child: SvgPicture.asset('assets/icons/hospital-colored.svg')),
          const SizedBox(
            width: 72.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                establecimiento.nombre,
                style: AppStyles.sectionTextStyle,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                  establecimiento.categoria!
                      .replaceAll('_', ' ')
                      .toProperCase(),
                  style: AppStyles.subSmallTextStyle),
              const SizedBox(
                width: 4,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 14.0,
                    color: AppColors.jadeGreen,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    establecimiento.telefono ?? '',
                    style: AppStyles.subSmallTextStyle
                        .copyWith(color: AppColors.jadeGreen),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
