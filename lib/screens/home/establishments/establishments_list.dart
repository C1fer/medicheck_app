import 'package:flutter/material.dart';
import 'package:medicheck/models/establecimiento_response.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/estabilshment_filter_dialog.dart';
import 'package:provider/provider.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/establecimiento.dart';
import '../../../widgets/cards/establishment_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/misc/search/search_row.dart';

class EstablishmentsList extends StatefulWidget {
  const EstablishmentsList({Key? key}) : super(key: key);
  static const String id = 'establishments_list';

  @override
  State<EstablishmentsList> createState() => _EstablishmentsListState();
}

class _EstablishmentsListState extends State<EstablishmentsList> {
  EstablecimientoResponse? establishments;

  final TextEditingController _establishmentsController =
      TextEditingController();
  String? establishmentType;

  @override
  void initState() {
    super.initState();
  }

  void _getEstablishments() async {
    try {
      if (mounted) {
        if (_establishmentsController.text != "") {
          final EstablecimientoResponse? response =
              await ApiService.getEstablishments(
                  keyword: _establishmentsController.text,
                  type: establishmentType);
          setState(() => establishments = response);
        } else {
          setState(() => establishments = null);
        }
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.affiliated_centers,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SearchBarWithFilter(
                    searchController: _establishmentsController,
                    hintText: locale.type_here,
                    onChanged: (String? val) => _getEstablishments(),
                    filterDialog: EstablishmentFilterDialog(
                      typeValue: establishmentType,
                      onTypeChanged: (String? newVal) =>
                          setState(() => establishmentType = newVal),
                      onButtonPressed: () async {
                        _getEstablishments();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                    child: establishments != null && establishments!.data.isNotEmpty
                        ? ListView.separated(
                            itemBuilder: (context, index) => EstablishmentCard(
                              establecimiento: establishments!.data[index],
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: establishments!.data.length,
                          )
                        : Center(child: Text(locale.no_results_shown)))
              ],
            )),
      ),
    );
  }
}
