import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/models/extensions/string_apis.dart';
import 'package:medicheck/models/incidente.dart';
import 'package:medicheck/models/misc/mock_data.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/incidente_response.dart';
import 'package:medicheck/styles/app_styles.dart';
import 'package:medicheck/widgets/cards/incident_card.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:medicheck/screens/home/incidents/new_incident.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/misc/custom_appbar.dart';
import '../../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../widgets/misc/skeletons/widget_skeleton_list.dart';

class IncidentReports extends StatefulWidget {
  const IncidentReports({Key? key}) : super(key: key);
  static const String id = 'incident_reports';

  @override
  State<IncidentReports> createState() => _IncidentReportsState();
}

class _IncidentReportsState extends State<IncidentReports> {
  String incidentStatus = 'ABIERTO';
  bool isLoading = true;

  final PagingController<int, Incidente> _incidentsPaginationController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _incidentsPaginationController.addPageRequestListener((pageKey) => _getIncidents());
    super.initState();
  }

  @override
  void dispose() {
    _incidentsPaginationController.dispose();
    super.dispose();
  }

  Future<bool> _getIncidents() async {
    if (mounted) {
      try {
        final int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
        final IncidenteResponse? response = await ApiService.getIncidentReports(
            userID: userID,
            status: incidentStatus,
            pageIndex: _incidentsPaginationController.nextPageKey ??
                _incidentsPaginationController.firstPageKey);

        if (response != null && response.data.isNotEmpty) {
          if (response.hasNextPage) {
            _incidentsPaginationController.appendPage(
                response.data, response.pageNumber + 1);
          } else {
            _incidentsPaginationController.appendLastPage(response.data);
          }
          return true;
        }
      } catch (except) {
        _incidentsPaginationController.error = except;
      }
    }
    return Future.error("Error fetching incidents");
  }

  Future<void> onStatusDropdownChanged(String? newVal) async {
    if (incidentStatus != newVal) {
      setState(() => incidentStatus = newVal!);
      _incidentsPaginationController.refresh();
    }
  }

  Future<void> onPressedNewIncidentButton() async {
    await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => NewIncident(onSubmit: () async {
              _incidentsPaginationController.refresh();
              Navigator.pop(context);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: locale.incident_reports,
      ),
      body: SafeArea(child: PageLayout(context, locale)),
    );
  }

  Widget PageLayout(BuildContext context, AppLocalizations locale) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StatusFilter(locale),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: _getIncidents(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(child: IncidentsList(context, locale));
                  } else if (snapshot.hasError) {
                    return Expanded(child: Center(child: Text(locale.no_results_shown)));
                  } else {
                    return Expanded(
                      child: WidgetSkeletonList(
                        widget: IncidentCard(
                          incident: MockData.incident,
                        ),
                        separator: const SizedBox(
                          height: 10,
                        ),
                        itemCount: 5,
                        ignoreContainers: false,
                      ),
                    );
                  }
                }),
            NewIncidentButton()
          ],
        ));
  }

  Widget StatusFilter(AppLocalizations locale) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 2,
            child: Text(
              locale.incident_status,
              style: AppStyles.settingTextStyle.copyWith(fontSize: 16),
            )),
        Expanded(
          flex: 3,
          child: CustomDropdownButton(
            optionsBorderRadius: 24.0,
            value: incidentStatus,
            onChanged: (String? val) => onStatusDropdownChanged(val),
            entries: Constants.incidentStatuses
                .map((element) => DropdownMenuItem(
                      value: element,
                      child: Text(element.contains("")
                          ? element.replaceAll("_", " ").toProperCase()
                          : element.toProperCase()),
                    ))
                .toList(),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget IncidentsList(BuildContext context, AppLocalizations locale) {
    return PagedListView.separated(
      pagingController: _incidentsPaginationController,
      builderDelegate: PagedChildBuilderDelegate<Incidente>(
          itemBuilder: (context, item, index) => IncidentCard(
                incident: item,
              ),
          noItemsFoundIndicatorBuilder: (context) =>
              Center(child: Text(locale.no_results_shown))),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget NewIncidentButton(){
    return Align(
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
    );
  }
}
