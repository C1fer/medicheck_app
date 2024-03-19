import 'package:flutter/material.dart';
import 'package:medicheck/models/enums.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/incidente_response.dart';
import 'package:medicheck/widgets/cards/incident_card.dart';
import 'package:medicheck/widgets/dropdown/custom_dropdown_button.dart';
import 'package:medicheck/widgets/misc/view_mode_button.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/new_incident_dialog.dart';
import 'package:medicheck/widgets/popups/dialog/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styles/app_colors.dart';

class IncidentReports extends StatefulWidget {
  const IncidentReports({Key? key}) : super(key: key);
  static const String id = 'incident_reports';

  @override
  State<IncidentReports> createState() => _IncidentReportsState();
}

class _IncidentReportsState extends State<IncidentReports> {
  IncidenteResponse? reports;
  incidentStatus? statusFilter;
  itemsViewMode viewMode = itemsViewMode.LIST;

  @override
  void initState() {
    super.initState();
    _getReports();
  }

  Future<void> _getReports() async {
    try {
      if (mounted) {
        final int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
        final IncidenteResponse? response =
            await ApiService.getIncidentReports(userID);
        setState(() => reports = response);
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> onStatusDropdownChanged(String? val) async {
    incidentStatus newStatus = incidentStatus.values
        .firstWhere((element) => element.toString() == val);
    setState(() => statusFilter = newStatus);
  }

  Future<void> onPressedNewIncidentButton() async {
    showCustomDialog(context, NewIncidentDialog(onSubmit: () async {}));
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
                /*Row(
                  children: [
                    // CustomDropdownButton(
                    //   value: statusFilter.toString(),
                    //   onChanged: (String? val) => onStatusDropdownChanged(val),
                    //   entries: incidentStatus.values
                    //       .map((element) => DropdownMenuItem(
                    //             value: element.toString(),
                    //             child: Text(element.toString()),
                    //           ))
                    //       .toList(),
                    //   isNullable: true,
                    // ),
                    ViewModeButton(
                      value: viewMode,
                      onTap: (newMode) => setState(() => viewMode = newMode),
                    )
                  ],
                ),*/
                if (reports != null && reports!.data.isNotEmpty)
                  Expanded(
                      child: viewMode == itemsViewMode.LIST
                          ? IncidentsListView(reports: reports)
                          : IncidentsGridView(reports: reports))
                else
                  Expanded(child: Center(child: Text(locale.no_results_shown))),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    onPressed: () {}, //disable new incicent dialog
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

class IncidentsListView extends StatelessWidget {
  const IncidentsListView({
    super.key,
    required this.reports,
  });

  final IncidenteResponse? reports;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => IncidentCard(
        incident: reports!.data[index],
        onTap: () {},
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: reports!.data.length,
    );
  }
}

class IncidentsGridView extends StatelessWidget {
  const IncidentsGridView({
    super.key,
    required this.reports,
  });

  final IncidenteResponse? reports;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Example: 2 columns
        crossAxisSpacing: 8, // Add spacing between columns
        mainAxisSpacing: 8, // Add spacing between rows
      ),
      itemBuilder: (context, index) => IncidentCard(
        incident: reports!.data[index],
        onTap: () {},
      ),
      itemCount: reports!.data.length,
      shrinkWrap: true,
    );
  }
}
