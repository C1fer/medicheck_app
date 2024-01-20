import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_styles.dart';

class CoverageDetailView extends StatefulWidget {
  const CoverageDetailView({super.key});

  static const String id = 'coverage_detail';

  @override
  State<CoverageDetailView> createState() => _CoverageDetailViewState();
}

class _CoverageDetailViewState extends State<CoverageDetailView> {
  @override
  Widget build(BuildContext context) {
    final coverage = ModalRoute.of(context)!.settings.arguments as Cobertura;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).coverage_details,
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
            children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 92,
              height: 92,
              child: SvgPicture.asset(
                'assets/icons/medical-history.svg',
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              coverage.idProductoNavigation.nombre,
              style: AppStyles.sectionTextStyle.copyWith(fontSize: 20.0),
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    '${coverage.porcentaje}% ${AppLocalizations.of(context).coverage_percentage}'),
                Icon(Icons.heart_broken),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              AppLocalizations.of(context).description,
              style: AppStyles.sectionTextStyle.copyWith(fontSize: 16),
            ),
            SizedBox(height: 12.0),
            Text(
              coverage.idProductoNavigation.descripcion,
              style: AppStyles.coverageCardCategoryTextStyle
                  .copyWith(fontSize: 12.0),
            ),
            FilledButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context).near_centers),
            ),
                    ],
                  ),
          )
      ),
    );
  }
}
