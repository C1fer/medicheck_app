import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/responses/cobertura_response.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/styles/app_decorations.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/utils/input_validation/validation_logic.dart';
import 'package:medicheck/widgets/inputs/custom_form_field.dart';
import 'package:medicheck/widgets/misc/custom_appbar.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../models/cobertura.dart';
import '../../../models/debouncer.dart';
import '../../../models/plan.dart';
import '../../../models/responses/establecimiento_response.dart';
import '../../../models/notifiers/plan_notifier.dart';
import '../../../models/producto.dart';
import '../../../styles/app_styles.dart';

class NewIncident extends StatefulWidget {
  const NewIncident({super.key, required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  State<NewIncident> createState() => _NewIncidentState();
}

class _NewIncidentState extends State<NewIncident> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _productController = TextEditingController();
  final _establishmentController = TextEditingController();
  final _dateController = TextEditingController();

  Establecimiento? selectedEstablishment;
  Producto? selectedProduct;
  String? pickedDate;

  Future<void> createIncident() async {
    int userID = context.read<UserInfoModel>().currentUserID!;
    int planID = context.read<PlanModel>().selectedPlanID!;
    await ApiService.postNewIncidentReport(
        userID,
        planID,
        selectedEstablishment!.idEstablecimiento,
        selectedProduct!.idProducto,
        _descriptionController.text,
        pickedDate!);
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
    return Scaffold(
        appBar: CustomAppBar(
          title: locale.new_incident,
          leading: Icon(Icons.close_rounded),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: ShapeDecoration(shape: RoundedRectangleBorder()),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DateField(context, locale),
                        const SizedBox(height: 20),
                        EstablishmentField(context, locale, currenPlan),
                        const SizedBox(height: 20),
                        ProductField(context, locale, currenPlan),
                        const SizedBox(height: 20),
                        DescriptionField(context, locale),
                        const SizedBox(height: 25),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: onSubmitPressed,
                          child: Text(locale.send)),
                    )],
                ),
              ),
            ),
          ),
        ));
  }

  Widget EstablishmentField(
      BuildContext context, AppLocalizations locale, Plan currentPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.establishment,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TypeAheadField<Establecimiento>(
            controller: _establishmentController,
            builder: (context, controller, focusNode) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: AppDecorations.formTextFieldDecoration
                    .copyWith(hintText: locale.establishment_placeholder),
                validator: (value) => validateAutoComplete(
                    value,
                    selectedEstablishment?.nombre.toProperCaseData(),
                    _establishmentController,
                    context)),
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
                    establishment.categoria.replaceUnderScores().toProperCaseData(),
                    style: AppStyles.subSmallTextStyle,
                  ),
                ),
            onSelected: (Establecimiento establishment) {
              setState(() {
                selectedEstablishment = establishment;
                _establishmentController.text = establishment.nombre.toProperCaseData();
              });
            },
            suggestionsCallback: (keyword) async {
              EstablecimientoResponse? responseData;
              if (keyword != "") {
                responseData = await ApiService.getEstablishments(
                    currentPlan.idAseguradoraNavigation.idAseguradora,
                    keyword: keyword);
              }
              return responseData?.data ?? [];
            }),
      ],
    );
  }

  Widget ProductField(
      BuildContext context, AppLocalizations locale, Plan currenPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.product,
            style: AppStyles.headingTextStyle
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TypeAheadField<Producto>(
            controller: _productController,
            builder: (context, controller, focusNode) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: AppDecorations.formTextFieldDecoration
                    .copyWith(hintText: locale.product_placeholder),
                validator: (value) => validateAutoComplete(value,
                    selectedProduct?.nombre.toProperCaseData(), _productController, context)),
            emptyBuilder: (context) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  locale.no_results_shown,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            itemBuilder: (context, product) => ListTile(
                  title: Text(product.nombre.toProperCaseData()),
                ),
            onSelected: (Producto product) {
              setState(() {
                selectedProduct = product;
                _productController.text = product.nombre.toProperCaseData();
              });
            },
            suggestionsCallback: (keyword) async {
              ProductoResponse? responseData;
              if (keyword != '') {
                responseData = await ApiService.getProductsAdvanced(
                    planID: currenPlan.idPlan, name: keyword);
              }
              return responseData?.data ?? [];
            }),
      ],
    );
  }

  Widget DescriptionField(BuildContext context, AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.description,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        CustomInputField(
          maxLines: null,
          minLines: 4,
          controller: _descriptionController,
          inputFormatters: [LengthLimitingTextInputFormatter(255)],
          validator: (String? val) => validateEmptyInput(val, context),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ],
    );
  }

  Widget DateField(BuildContext context, AppLocalizations locale) {
    Future<void> pickDate() async {
      DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(), //get today's date
          firstDate: DateTime(
              2024), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));

      if (selectedDate != null) {
        setState(() {
          pickedDate = selectedDate.toIso8601String();
          _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate).toString();
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.incident_date,
          style: AppStyles.headingTextStyle
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _dateController,
          decoration: AppDecorations.formTextFieldDecoration
              .copyWith(hintText: locale.date_picker_placeholder),
          validator: (value) => validateEmptyInput(value, context),
          onTap: () => pickDate(),
          readOnly: true,
        )
      ],
    );
  }
}
