import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medicheck/models/responses/cobertura_response.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/styles/app_decorations.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/inputs/custom_form_field.dart';
import 'package:provider/provider.dart';

import '../../../../models/cobertura.dart';
import '../../../../models/debouncer.dart';
import '../../../../models/plan.dart';
import '../../../../models/responses/establecimiento_response.dart';
import '../../../../models/notifiers/plan_notifier.dart';
import '../../../../models/producto.dart';
import '../../../../styles/app_styles.dart';

class NewIncidentDialog extends StatefulWidget {
  const NewIncidentDialog({super.key, required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  State<NewIncidentDialog> createState() => _NewIncidentDialogState();
}

class _NewIncidentDialogState extends State<NewIncidentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _productController = TextEditingController();
  final _establishmentController = TextEditingController();

  Establecimiento? selectedEstablishment;
  Producto? selectedProduct;

  Future<void> createIncident() async {
    int userID = context.read<UserInfoModel>().currentUserID!;
    int planID = context.read<PlanModel>().selectedPlanID!;
    await ApiService.postNewIncidentReport(
        userID,
        planID,
        selectedEstablishment!.idEstablecimiento,
        selectedProduct!.idProducto,
        _descriptionController.text);
    widget.onSubmit();
  }

  bool validateForm(GlobalKey<FormState> form) {
    return form.currentState?.validate() ?? false;
  }

  void onSubmitPressed() {
    if (validateForm(_formKey)) {
      createIncident();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    Plan currenPlan = context.read<PlanModel>().selectedPlan!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
            locale.new_incident,
            style: AppStyles.headingTextStyle.copyWith(fontSize: 18.0),
          )),
          const SizedBox(height: 16.0),
          Text(locale.establishment,
              style: AppStyles.headingTextStyle
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TypeAheadField<Establecimiento>(
              controller: _establishmentController,
              builder: (context, controller, focusNode) => TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: AppDecorations.formTextFieldDecoration
                      .copyWith(hintText: locale.type_here),
                  validator: (value) => validateEmptyInput(value, context)),
              emptyBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    locale.no_results_shown,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
              itemBuilder: (context, establishment) => ListTile(
                    title: Text(establishment.nombre),
                    subtitle: Text(
                      establishment.categoria!,
                      style: AppStyles.subSmallTextStyle,
                    ),
                  ),
              onSelected: (Establecimiento establishment) {
                setState(() {
                  selectedEstablishment = establishment;
                  _establishmentController.text = establishment.nombre;
                });
              },
              suggestionsCallback: (keyword) async {
                EstablecimientoResponse? responseData;
                if (keyword != "") {
                  responseData = await ApiService.getEstablishments(arsID:currenPlan.idAseguradoraNavigation.idAseguradora, keyword: keyword);
                }
                return responseData?.data ?? [];
              }),
          const SizedBox(
            height: 20,
          ),
          Text(locale.product,
              style: AppStyles.headingTextStyle
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TypeAheadField<Producto>(
              controller: _productController,
              builder: (context, controller, focusNode) => TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: AppDecorations.formTextFieldDecoration
                        .copyWith(hintText: locale.type_here),
                    validator: (value) => validateEmptyInput(value, context),
                  ),
              emptyBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    locale.no_results_shown,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
              itemBuilder: (context, product) => ListTile(
                    title: Text(product.nombre),
                  ),
              onSelected: (Producto product) {
                setState(() {
                  selectedProduct = product;
                  _productController.text = product.nombre;
                });
              },
              suggestionsCallback: (keyword) async {
                ProductoResponse? responseData;
                if (keyword != '') {
                  responseData = await ApiService.getProductsAdvanced(planID: currenPlan.idPlan, name: keyword);
                }
                return responseData?.data ?? [];
              }),
          const SizedBox(
            height: 20,
          ),
          Text(
            locale.description,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          CustomInputField(
            controller: _descriptionController,
            inputFormatters: [LengthLimitingTextInputFormatter(255)],
            validator: (String? val) => validateEmptyInput(val, context),
            hintText: locale.type_here,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            maxLines: null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: onSubmitPressed, child: Text(locale.send)),
          )
        ],
      ),
    );
  }
}
