import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/establecimiento_response.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
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
  final _establishmentsController = TextEditingController();
  final _establishmentsPaginationController =
      PagingController<int, Establecimiento>(firstPageKey: 1);

  EstablecimientoResponse? establishments;

  String? establishmentType;

  @override
  void initState() {
    super.initState();
    _establishmentsPaginationController
        .addPageRequestListener((pageKey) => _getEstablishments());
    _getEstablishments();
  }

  void _getEstablishments() async {
    try {
      if (mounted) {
        final EstablecimientoResponse? response =
            await ApiService.getEstablishments(
                arsID: context.read<PlanModel>().selectedPlanID,
                keyword: _establishmentsController.text,
                type: establishmentType,
                pageIndex: _establishmentsPaginationController.nextPageKey);

        if (response != null) {
          if (response.hasNextPage) {
            _establishmentsPaginationController.appendPage(
                response.data, response.pageNumber + 1);
          } else {
            _establishmentsPaginationController.appendLastPage(response.data);
          }
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
                    child: _establishmentsPaginationController != null &&
                            _establishmentsPaginationController
                                .itemList!.isNotEmpty
                        ? PagedListView.separated(
                            pagingController:
                                _establishmentsPaginationController,
                            builderDelegate:
                                PagedChildBuilderDelegate<Establecimiento>(
                                    itemBuilder: (context, item, index) =>
                                        EstablishmentCard(
                                          establecimiento: item,
                                        )),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          )
                        : Center(child: Text(locale.no_results_shown)))
              ],
            )),
      ),
    );
  }
}
