import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/responses/establecimiento_response.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:medicheck/widgets/misc/skeletons/widget_skeleton_list.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/estabilshment_filter_dialog.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../models/misc/mock_data.dart';
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
      PagingController<int, Establecimiento>(
          firstPageKey: 1, invisibleItemsThreshold: 3);

  EstablecimientoResponse? establishments;
  String? establishmentType;

  @override
  void initState() {
    _establishmentsPaginationController.addPageRequestListener((pageKey) {
      _getEstablishments();
      print(_establishmentsPaginationController.itemList!.length);
    });
    super.initState();
  }

  @override
  void dispose() {
    _establishmentsPaginationController.dispose();
    super.dispose();
  }

  Future<bool> _getEstablishments() async {
    if (mounted) {
      final int arsID = context
          .read<PlanModel>()
          .selectedPlan!
          .idAseguradoraNavigation
          .idAseguradora;
      final EstablecimientoResponse? response =
          await ApiService.getEstablishments(arsID,
              keyword: _establishmentsController.text,
              type: establishmentType,
              pageSize: 4,
              pageIndex: _establishmentsPaginationController.nextPageKey ??
                  _establishmentsPaginationController.firstPageKey);

      if (response != null && response!.data.isNotEmpty) {
        if (response.hasNextPage) {
          _establishmentsPaginationController.appendPage(
              response.data, response.pageNumber + 1);
        } else {
          _establishmentsPaginationController.appendLastPage(response.data);
        }
        return true;
      }
    }
    return Future.error("");
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.affiliated_centers,
      ),
      body: SafeArea(child: PageLayout(context, locale)),
    );
  }

  Widget PageLayout(BuildContext context, AppLocalizations locale) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
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
                onApplyButtonPressed: () async {
                  _establishmentsPaginationController.refresh();
                  Navigator.pop(context);
                },
                onResetButtonPressed: () =>
                    setState(() => establishmentType = null),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          FutureBuilder(
              future: _getEstablishments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(child: EstablishmentsList());
                } else if (snapshot.hasError) {
                  return Expanded(
                      child: Center(child: Text(locale.no_results_shown)));
                } else {
                  return Expanded(
                    child: WidgetSkeletonList(
                      widget: EstablishmentCard(
                          establecimiento: MockData.establishment),
                      separator: const SizedBox(
                        height: 10,
                      ),
                      itemCount: 10,
                      ignoreContainers: false,
                    ),
                  );
                }
              })
        ]));
  }

  Widget EstablishmentsList() {
    return PagedListView.separated(
      pagingController: _establishmentsPaginationController,
      builderDelegate: PagedChildBuilderDelegate<Establecimiento>(
          itemBuilder: (context, item, index) => EstablishmentCard(
                establecimiento: item,
              ),
          newPageProgressIndicatorBuilder: (context) =>
              const DataLoadingIndicator()),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
