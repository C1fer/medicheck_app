import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/screens/home/coverage/coverage_details.dart';
import 'package:provider/provider.dart';
import '../../models/cobertura.dart';
import '../../models/enums.dart';
import '../../models/notifiers/recent_query_notifier.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../styles/app_styles.dart';
import '../../utils/api/api_service.dart';
import '../../widgets/cards/feature_card.dart';
import '../../utils/cached_coverages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoverageCardSmall extends StatelessWidget {
  const CoverageCardSmall({super.key, required this.coverage, this.onTap});

  final Cobertura coverage;
  final void Function()? onTap;

  Future<void> onSelected(BuildContext context, Cobertura selectedCoverage) async {
    int userId = context.read<UserInfoModel>().currentUser!.idUsuario;
    bool response = await ApiService.postRecentQuery(userId, selectedCoverage.idCobertura);

    if (response) {
      // Update selected coverage global state
      await context.read<ViewedCoverageModel>().set(selectedCoverage);
      // Navigate to details screen
      Navigator.pushNamed(context, CoverageDetailView.id,
          arguments: selectedCoverage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap ?? onSelected(context, coverage),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 36,
                  height: 36,
                  child: SvgPicture.asset(
                    Constants.productTypeIcons[coverage.idProductoNavigation.tipo]!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      coverage.idProductoNavigation.nombre,
                      style: AppStyles.coverageCardHeadingTextStyle
                          .copyWith(fontSize: 16.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      coverage.idProductoNavigation.descripcion,
                      style: AppStyles.subSmallTextStyle.copyWith(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context).coverage,
                  style: AppStyles.coverageCardCategoryTextStyle
                      .copyWith(fontSize: 12.0),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    child: FeatureCard(msg: '${coverage.porcentaje} %'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
