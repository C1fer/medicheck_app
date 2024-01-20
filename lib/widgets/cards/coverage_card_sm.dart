import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import '../../utils/cached_coverages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoverageCardSmall extends StatelessWidget {
  const CoverageCardSmall({super.key, required this.coverage});

  final Cobertura coverage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CachedCoveragesService.add(coverage);
        Navigator.pushNamed(context, CoverageDetailView.id,
            arguments: coverage);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            width: 36,
            height: 36,
            child: SvgPicture.asset(
              'assets/icons/medical-history.svg',
              fit: BoxFit.fitHeight,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16.0),
              Text(
                coverage.idProductoNavigation.nombre,
                style: AppStyles.coverageCardHeadingTextStyle
                    .copyWith(fontSize: 16.0),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                coverage.idProductoNavigation.descripcion,
                style: AppStyles.subSmallTextStyle.copyWith(fontSize: 12.0),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context).coverage,
                  style: AppStyles.coverageCardCategoryTextStyle
                      .copyWith(fontSize: 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 4.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: FeatureCard(msg: '${coverage.porcentaje} %')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
