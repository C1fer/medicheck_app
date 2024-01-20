import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/widgets/cards/feature_card.dart';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 120,
                height: 120,
                child: SvgPicture.asset(
                  'assets/icons/medical-history.svg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(
              height: 75.0,
            ),
            Text(
              coverage.idProductoNavigation.nombre,
              style: AppStyles.sectionTextStyle.copyWith(fontSize: 30.0),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${coverage.porcentaje}% ${AppLocalizations.of(context).coverage_percentage}',
                  style: AppStyles.actionTextStyle
                      .copyWith(fontSize: 26, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Text(
              AppLocalizations.of(context).details,
              style: AppStyles.sectionTextStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                FeatureCard(msg: coverage.idProductoNavigation.tipo),
                const SizedBox(
                  width: 20,
                ),
                if (coverage.idProductoNavigation.tipo !=
                    coverage.idProductoNavigation.categoria)
                  (FeatureCard(
                    msg: coverage.idProductoNavigation.categoria,
                  )),
              ],
            ),
            const SizedBox(height: 24.0),
            Text(
              AppLocalizations.of(context).description,
              style: AppStyles.sectionTextStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 11.0),
            Text(
              coverage.idProductoNavigation.descripcion,
              style: AppStyles.coverageCardCategoryTextStyle
                  .copyWith(fontSize: 18),
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context).near_centers),
            ),
          ],
        ),
      )),
    );
  }
}
