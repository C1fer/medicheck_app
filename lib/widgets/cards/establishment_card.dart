import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/establecimiento.dart';
import '../../styles/app_styles.dart';
import '../../styles/app_colors.dart';

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
          Skeleton.replace(
            replacement: Bone.square(
              size: 72,
              borderRadius: BorderRadius.circular(15),
            ),
            child: EstablishmentIcon(),
          ),
          const SizedBox(
            width: 30.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  establecimiento.nombre.toProperCaseData(),
                  style: AppStyles.sectionTextStyle,
                ),
                Text(
                    establecimiento.categoria!
                        .replaceUnderScores()
                        .toProperCase(),
                    style: AppStyles.subSmallTextStyle),
                const SizedBox(
                  height: 4,
                ),
                if (establecimiento.telefono != null) EstablishmentPhoneNo(),
                const SizedBox(
                  height: 4,
                ),
                if (establecimiento.direccion != null) EstablishmentLocation(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget EstablishmentIcon() {
    return SizedBox(
        width: 72,
        height: 72,
        child: SvgPicture.asset('assets/icons/hospital-colored.svg'));
  }

  Widget EstablishmentLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 14.0,
          color: AppColors.jadeGreen,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            establecimiento.direccion!.toProperCaseData(),
            style: AppStyles.subSmallTextStyle
                .copyWith(color: AppColors.jadeGreen),
          ),
        )
      ],
    );
  }

  Widget EstablishmentPhoneNo() {
    return Column(
        children: establecimiento.telefono!
            .split(", ")
            .map((String phoneNo) => Row(
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
                      phoneNo,
                      style: AppStyles.subSmallTextStyle
                          .copyWith(color: AppColors.jadeGreen),
                    ),
                  ],
                ))
            .toList());
  }
}
