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
import '../../../../widgets/misc/custom_appbar.dart';
import '../../../../utils/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../styles/app_colors.dart';
import '../../../styles/app_styles.dart';

class IncidentReports extends StatefulWidget {
  const IncidentReports({Key? key}) : super(key: key);
  static const String id = 'incident_reports';

  @override
  State<IncidentReports> createState() => _IncidentReportsState();
}

class _IncidentReportsState extends State<IncidentReports> {
  IncidenteResponse? reports;
  String incidentStatus = 'ABIERTO';
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
            await ApiService.getIncidentReports(userID, incidentStatus);
        setState(() => reports = response);
      }
    } catch (ex) {
      print(ex);
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
                        onChanged: (String? val) => onStatusDropdownChanged(val),
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
                SizedBox(height: 20,),
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
                    onPressed: () async => await showCustomDialog(context,
                        NewIncidentDialog(onSubmit: () async {
                      _getReports;
                      Navigator.pop(context);
                    })), //disable new incicent dialog
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
