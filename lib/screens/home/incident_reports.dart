import 'package:flutter/material.dart';
import 'package:medicheck/models/establecimiento_response.dart';
import 'package:medicheck/models/incident.dart';
import 'package:medicheck/models/notifiers/plan_notifier.dart';
import 'package:medicheck/models/notifiers/user_info_notifier.dart';
import 'package:medicheck/models/responses/incident_response.dart';
import 'package:medicheck/widgets/cards/incident_card.dart';
import 'package:medicheck/widgets/popups/dialog/dialogs/estabilshment_filter_dialog.dart';
import 'package:provider/provider.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/establecimiento.dart';
import '../../../widgets/cards/establishment_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/misc/search/search_row.dart';

class IncidentReports extends StatefulWidget {
  const IncidentReports({Key? key}) : super(key: key);
  static const String id = 'incident_reports';

  @override
  State<IncidentReports> createState() => _IncidentReportsState();
}

class _IncidentReportsState extends State<IncidentReports> {
  ReporteResponse? reports;

  final TextEditingController _reportsController = TextEditingController();
  String? reportStatus;


  @override
  void initState() {
    super.initState();
    _getReports();
  }

  void _getReports() async {
    try {
      if (mounted) {
        final int userID = context.read<UserInfoModel>().currentUser!.idUsuario;
        final ReporteResponse? response =
            await ApiService.getIncidentReports(userID);
        setState(() => reports = response);
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
                Expanded(
                    child: reports != null &&
                            reports!.data.isNotEmpty
                        ? ListView.separated(
                            itemBuilder: (context, index) => IncidentCard(
                              incident: reports!.data[index],
                              onTap: () {},
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: reports!.data.length,
                          )
                        : Center(child: Text(locale.no_results_shown)))
              ],
            )),
      ),
    );
  }
}
