import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medicheck/models/cobertura_response.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/styles/app_decorations.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/inputs/custom_form_field.dart';
import 'package:medicheck/widgets/inputs/text_field.dart';
import 'package:provider/provider.dart';

import '../../../../models/cobertura.dart';
import '../../../../models/debouncer.dart';
import '../../../../models/establecimiento_response.dart';
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Text(
            locale.filter_options,
            style: AppStyles.headingTextStyle.copyWith(fontSize: 18.0),
          )),
          const SizedBox(height: 16.0),
          Text(
            locale.description,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          CustomTextField(controller: _descriptionController),
          const SizedBox(
            height: 20,
          ),
          Text(locale.establishment,
              style: AppStyles.headingTextStyle
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TypeAheadField<Establecimiento>(
              controller: _establishmentController,
              builder: (context, controller, focusNode) => TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: AppDecorations.formTextFieldDecoration,
                  validator: (value) => validateEmptyInput(value, context)),
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
                int planID = context.read<PlanModel>().selectedPlanID!;
                EstablecimientoResponse? responseData;
                if (keyword != "") {
                  responseData = await ApiService.getEstablishments(
                      arsID: planID, keyword: keyword);
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
          TypeAheadField<Cobertura>(
              controller: _productController,
              builder: (context, controller, focusNode) => TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration:
                        AppDecorations.formTextFieldDecoration.copyWith(),
                    validator: (value) => validateEmptyInput(value, context),
                  ),
              itemBuilder: (context, coverage) => ListTile(
                    title: Text(coverage.idProductoNavigation.nombre),
                  ),
              onSelected: (Cobertura coverage) {
                setState(() {
                  selectedProduct = coverage.idProductoNavigation;
                  _productController.text =
                      coverage.idProductoNavigation.nombre;
                });
              },
              suggestionsCallback: (keyword) async {
                CoberturaResponse? responseData;
                if (keyword != '') {
                  responseData = await ApiService.getCoveragesAdvanced(
                    planID: context.read<PlanModel>().selectedPlanID!,
                    name: keyword,
                  );
                }
                return responseData?.data ?? [];
              }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: onSubmitPressed, child: const Text('OK')),
          )
        ],
      ),
    );
  }
}
