import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/plan.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:provider/provider.dart';

import '../../../../models/enums.dart';
import '../../../../models/tipo_producto.dart';
import '../../../../styles/app_styles.dart';
import '../../../dropdown/custom_dropdown_button.dart';

class ProductFilterDialog extends StatefulWidget {
  ProductFilterDialog(
      {super.key, required this.types,
      this.typeID,
      this.categoryValue,
      required this.onCategoryChanged,
      required this.onTypeChanged,
      required this.onApplyButtonPressed,
      required this.onResetButtonPressed});

  List<TipoProducto> types;
  String? typeID;
  String? categoryValue;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onTypeChanged;
  final void Function() onApplyButtonPressed;
  final void Function() onResetButtonPressed;

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  void _resetFields() {
    setState(() {
      widget.categoryValue = "ALL";
      widget.typeID = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final planModel = context.read<PlanModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Header(locale),
        const SizedBox(height: 24.0),
        TypeField(locale),
        // Filter by PDSS or Complementary Plan (Exclusive to Complementary Plans)
        if (planModel.selectedPlan!.idRegimenNavigation.id == 3)
          PlanField(locale, planModel),
        const SizedBox(height: 32),
        ActionButtons(locale)
      ],
    );
  }

  Widget Header(AppLocalizations locale) {
    return Row(
      children: [
        const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.jadeGreen,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          locale.filter_options,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 18.0, color: AppColors.jadeGreen),
        ),
      ],
    );
  }

  Widget TypeField(AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.product_type,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
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
            entries: widget.types
                .map((type) => DropdownMenuItem(
                    value: type.id.toString(), child: Text(type.nombre)))
                .toList()),
      ],
    );
  }

  Widget PlanField(AppLocalizations locale, PlanModel planModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(locale.plan,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
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
                value: "ALL",
                child: Text(locale.select_an_option)),
            DropdownMenuItem(
                value: "COMP",
                child: Text(planModel.selectedPlan!.descripcion)),
            DropdownMenuItem(value: "PDSS", child: Text(locale.pdss)),
          ],
        ),
      ],
    );
  }

  Widget ActionButtons(AppLocalizations locale) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () {
                _resetFields();
                widget.onResetButtonPressed();
              },
              child: Text(locale.reset)),
        ),
        const SizedBox(width: 12,),
        Expanded(
          child: FilledButton(
              onPressed: widget.onApplyButtonPressed, child: Text(locale.apply)),
        ),
      ],
    );
  }
}
