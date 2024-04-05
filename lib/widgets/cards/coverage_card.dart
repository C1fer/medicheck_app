import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../models/extensions/string_apis.dart';
import '../../models/cobertura.dart';
import '../../models/notifiers/recent_query_notifier.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../screens/home/coverage/coverage_details.dart';
import '../../styles/app_styles.dart';
import '../../utils/api/api_service.dart';
import '../../widgets/cards/feature_card.dart';
import '../../models/enums.dart';

class CoverageCard extends StatelessWidget {
  const CoverageCard({super.key, required this.coverage, this.onTap});

  final Cobertura coverage;
  final void Function()? onTap;

  Future<void> onSelected(
      BuildContext context, Cobertura selectedCoverage) async {
    int userId = context.read<UserInfoModel>().currentUser!.idUsuario;
    bool response =
        await ApiService.postRecentQuery(userId, selectedCoverage.idCobertura);

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
      onTap: () async => onTap ?? onSelected(context, coverage),
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 54,
              height: 54,
              child: SvgPicture.asset(
                Constants.productTypeIcons[coverage.idProductoNavigation.tipo]!,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: Text(
                coverage.idProductoNavigation.nombre,
                style: AppStyles.coverageCardHeadingTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              coverage.idProductoNavigation.tipo.toSentenceCase(),
              style: AppStyles.coverageCardCategoryTextStyle,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
              child: FeatureCard(
                msg: '${coverage.porcentaje}%',
              ),
            )
          ],
        ),
      ),
    );
  }
}
