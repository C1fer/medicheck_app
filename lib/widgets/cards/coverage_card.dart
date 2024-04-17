import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/cobertura.dart';
import '../../styles/app_styles.dart';
import '../../widgets/cards/feature_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoverageCard extends StatelessWidget {
  const CoverageCard({super.key, required this.coverage});

  final Cobertura coverage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 9,
          child: Row(
            children: [
              Skeleton.replace(replacement: const Bone.circle(size: 36),child: CoverageIcon(),),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: CoverageInfo(),),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: CoveragePercentage(context),
        ),
      ],
    );
  }

  Widget CoverageIcon() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 36,
      height: 36,
      child: SvgPicture.asset(
        'assets/icons/pill.svg',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget CoverageInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          coverage.idSubGrupoNavigation.idGrupoNavigation.nombre
              .toProperCaseData(),
          style:
              AppStyles.coverageCardHeadingTextStyle.copyWith(fontSize: 14.0),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left),
      const SizedBox(
        height: 4.0,
      ),
      Text(
        coverage.idSubGrupoNavigation.nombre.toProperCaseData(),
        style: AppStyles.subSmallTextStyle.copyWith(fontSize: 12.0),
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }

  Widget CoveragePercentage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppLocalizations.of(context).coverage,
          style:
              AppStyles.coverageCardCategoryTextStyle.copyWith(fontSize: 12.0),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Consumer<PlanModel>(
                builder: (context, planModel, _) => FeatureCard(
                    msg: planModel.selectedPlan!.idRegimenNavigation
                                .descripcion ==
                            "SUBSIDIADO"
                        ? "100 %"
                        : '${coverage.porcentaje} %')),
          ),
        )
      ],
    );
  }
}
