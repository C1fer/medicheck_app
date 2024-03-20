import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/incidente.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/incidente_response.dart';
import 'package:medicheck/widgets/cards/incident_card.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/new_incident_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/misc/custom_appbar.dart';
import '../../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';

class IncidentReports extends StatefulWidget {
  const IncidentReports({Key? key}) : super(key: key);
  static const String id = 'incident_reports';

  @override
  State<IncidentReports> createState() => _IncidentReportsState();
}

class _IncidentReportsState extends State<IncidentReports> {
  String incidentStatus = 'ABIERTO';
  final PagingController<int, Incidente> _incidentsPaginationController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _incidentsPaginationController
        .addPageRequestListener((pageKey) => _getReports());
    super.initState();
  }

  @override
  void dispose() {
    _incidentsPaginationController.dispose();
    super.dispose();
  }

  Future<void> _getReports() async {
    if (mounted) {
      try {
        final int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
        final IncidenteResponse? response = await ApiService.getIncidentReports(
            userID: userID,
            status: incidentStatus,
            pageIndex: _incidentsPaginationController.nextPageKey ??
                _incidentsPaginationController.firstPageKey);

        if (response != null) {
          if (response.hasNextPage) {
            _incidentsPaginationController.appendPage(
                response.data, response.pageNumber + 1);
          } else {
            _incidentsPaginationController.appendLastPage(response.data);
          }
        }
      } catch (except) {
        _incidentsPaginationController.error = except;
      }
    }
  }

  Future<void> onStatusDropdownChanged(String? newVal) async {
    if (incidentStatus != newVal) {
      setState(() => incidentStatus = newVal!);
      _incidentsPaginationController.refresh();
    }
  }

  Future<void> onPressedNewIncidentButton() async {
    await showCustomDialog(context, NewIncidentDialog(onSubmit: () async {
      _incidentsPaginationController.refresh();
      Navigator.pop(context);
    }), dismissible: true);
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.incident_reports,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 6,
                      child: CustomDropdownButton(
                        optionsBorderRadius: 24.0,
                        value: incidentStatus,
                        onChanged: (String? val) =>
                            onStatusDropdownChanged(val),
                        entries: Constants.incidentStatuses
                            .map((element) => DropdownMenuItem(
                                  value: element,
                                  child: Text(element.contains("")
                                      ? element
                                          .replaceAll("_", " ")
                                          .toProperCase()
                                      : element.toProperCase()),
                                ))
                            .toList(),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: PagedListView.separated(
                  pagingController: _incidentsPaginationController,
                  builderDelegate: PagedChildBuilderDelegate<Incidente>(
                    itemBuilder: (context, item, index) => IncidentCard(
                      incident: item,
                      onTap: () {},
                    ),
                    noItemsFoundIndicatorBuilder: (context) =>
                        Center(child: Text(locale.no_results_shown)),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: onPressedNewIncidentButton,
                    backgroundColor: AppColors.jadeGreen,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
