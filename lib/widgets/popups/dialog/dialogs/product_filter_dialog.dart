import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums.dart';
import '../../../../models/tipo_producto.dart';
import '../../../../styles/app_styles.dart';
import '../../../dropdown/custom_dropdown_button.dart';

class ProductFilterDialog extends StatefulWidget {
  ProductFilterDialog(
      {super.key,
      this.typeID,
      this.categoryValue,
      required this.onCategoryChanged,
      required this.onTypeChanged,
      required this.onButtonPressed});

  String? typeID;
  String? categoryValue;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onTypeChanged;
  final Future<void> Function() onButtonPressed;

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  List<TipoProducto> productTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final List<TipoProducto> response = await ApiService.getProductType();
    setState(() => productTypes = response);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Consumer<PlanModel>(
        builder: (context, planModel, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Text(
                  locale.filter_options,
                  style: AppStyles.headingTextStyle.copyWith(fontSize: 18.0),
                )),
                const SizedBox(height: 16.0),
                Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.type,
                      style: AppStyles.headingTextStyle.copyWith(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    CustomDropdownButton(
                        value: widget.typeID,
                        isNullable: true,
                        isExpanded: true,
                        onChanged: (String? newVal) {
                          setState(() => widget.typeID = newVal);
                          widget.onTypeChanged(newVal);
                        },
                        entries: productTypes
                            .map((type) => DropdownMenuItem(
                                value: type.id.toString(),
                                child: Text(type.nombre)))
                            .toList()),
                  ],
                ),

                // Filter by PDSS or Complementary Plan (Exclusive to Complementary Plans)
                if (planModel.selectedPlan!.idRegimenNavigation.id == 3)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(locale.category,
                          style: AppStyles.headingTextStyle.copyWith(
                              fontSize: 16.0, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      CustomDropdownButton(
                        value: widget.categoryValue,
                        isNullable: false,
                        isExpanded: true,
                        onChanged: (String? newVal) {
                          setState(() => widget.categoryValue = newVal);
                          widget.onCategoryChanged(newVal);
                        },
                        entries: [
                          DropdownMenuItem(
                              value: "ALL", child: Text(locale.all_products)),
                          DropdownMenuItem(
                              value: "COMP",
                              child: Text(planModel.selectedPlan!.descripcion)),
                          DropdownMenuItem(
                              value: "PDSS", child: Text(locale.pdss)),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: widget.onButtonPressed,
                      child: const Text('OK')),
                )
              ],
            ));
  }
}
