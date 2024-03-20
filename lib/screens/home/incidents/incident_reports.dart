import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/enums.dart';
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
  final _incidentsPaginationController =
      PagingController<int, Incidente>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _getReports();
  }

  Future<void> _getReports() async {
    if (mounted) {
      final int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
      final IncidenteResponse? response = await ApiService.getIncidentReports(
          userID: userID,
          status: incidentStatus,
          pageIndex: _incidentsPaginationController.nextPageKey);

      if (response != null) {
        if (response.hasNextPage) {
          _incidentsPaginationController.appendPage(
              response.data, response.pageNumber + 1);
        } else {
          _incidentsPaginationController.appendLastPage(response.data);
        }
      }
    }
  }

  Future<void> onStatusDropdownChanged(String? newVal) async {
    setState(() => incidentStatus = newVal!);
    _getReports();
  }

  Future<void> onPressedNewIncidentButton() async {
    showCustomDialog(context, NewIncidentDialog(onSubmit: () async {}));
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
                                  child: Text(element),
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
                    child: _incidentsPaginationController.itemList != null &&
                            _incidentsPaginationController.itemList!.isNotEmpty
                        ? PagedListView.separated(
                            pagingController: _incidentsPaginationController,
                            builderDelegate:
                                PagedChildBuilderDelegate<Incidente>(
                              itemBuilder: (context, item, index) =>
                                  IncidentCard(
                                incident: item,
                                onTap: () {},
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          )
                        : Center(child: Text(locale.no_results_shown))),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () async => await showCustomDialog(context,
                        NewIncidentDialog(onSubmit: () async {
                      _getReports;
                      Navigator.pop(context);
                    })),
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
