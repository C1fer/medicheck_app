import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:provider/provider.dart';

import '../../models/producto.dart';
import '../../models/notifiers/recent_query_notifier.dart';
import '../../models/notifiers/user_info_notifier.dart';
import '../../screens/home/coverage/coverage_details.dart';
import '../../styles/app_styles.dart';
import '../../utils/api/api_service.dart';
import '../../models/enums.dart';
import 'feature_card.dart';

class ProductCardSmall extends StatelessWidget {
  const ProductCardSmall({super.key, required this.product, this.onTap});

  final Producto product;
  final void Function()? onTap;

  Future<void> onSelected(BuildContext context) async {
    int userId = context.read<UserInfoModel>().currentUser!.idUsuario;
    Navigator.pushNamed(context, CoverageDetailView.id,
        arguments: product);

    bool response = await ApiService.postRecentQuery(userId, product.idProducto);
    if (response) {
      // Update selected coverage global state
      await context.read<ViewedCoverageModel>().set(product);

    }}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap ?? onSelected(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 9,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    'assets/icons/pill.svg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      product.nombre.toProperCaseData(),
                      maxLines: 2,
                      style: AppStyles.coverageCardHeadingTextStyle
                          .copyWith(fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      product.idTipoProductoNavigation!.nombre.toProperCaseData(),
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
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4.0, vertical: 4.0),
                child: FeatureCard(msg: product.isPDSS ? "Básico" : "Complementario"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
