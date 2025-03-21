import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/notifiers/plan_notifier.dart';
import '../../models/producto.dart';
import '../../models/notifiers/recent_query_notifier.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../screens/home/coverage/coverage_overview.dart';
import '../../styles/app_styles.dart';
import '../../utils/api/api_service.dart';
import '../../models/enums.dart';
import 'feature_card.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Producto product;
  final void Function()? onTap;

  Future<void> onSelected(BuildContext context) async {
    int userId = context.read<UserInfoModel>().currentUser!.idUsuario;
    int planId = context.read<PlanModel>().selectedPlanID!;
    Navigator.pushNamed(context, CoverageOverview.id, arguments: product);

    bool response =
        await ApiService.postRecentQuery(userId, product.idProducto, planId);
    if (response) {
      // Update selected coverage global state
      await context.read<ViewedCoverageModel>().set(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => onTap ?? onSelected(context),
      child: Container(
        width: 130,
        height: 175,
        padding: const EdgeInsets.all(12.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFE8F3F1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton.replace(
                replacement: Bone.square(
                  size: 54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ProductIcon(),
              ),
              const SizedBox(height: 16.0),
              ProductName(),
              const SizedBox(
                height: 4.0,
              ),
              ProductType(),
              ProductPlanOrigin()
            ],
          ),
        ),
      ),
    );
  }

  Widget ProductIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 54,
      height: 54,
      child: SvgPicture.asset(
        'assets/icons/pill.svg',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget ProductName() {
    return Text(
      product.nombre.toProperCaseData(),
      style: AppStyles.coverageCardHeadingTextStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget ProductType() {
    return Text(
      product.idTipoProductoNavigation!.nombre.toProperCaseData(),
      style: AppStyles.coverageCardCategoryTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget ProductPlanOrigin() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
        child: FeatureCard(
          msg: product.isPDSS ? "Básico" : "Compl.",
        ));
  }
}
