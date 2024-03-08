import 'package:flutter/material.dart';
import 'package:medicheck/models/establecimiento_response.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/establecimiento.dart';
import '../../../widgets/cards/establishment_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EstablishmentsList extends StatefulWidget {
  const EstablishmentsList({super.key});
  static const String id = 'establishments_list';

  @override
  State<EstablishmentsList> createState() => _EstablishmentsListState();
}

class _EstablishmentsListState extends State<EstablishmentsList> {
  EstablecimientoResponse? establishments;

  @override
  void initState() {
    super.initState();
    _getEstablishments();
  }

  void _getEstablishments() async {
    try {
      final EstablecimientoResponse? response =
          await ApiService.getEstablishments();
      if (mounted) {
        setState(() => establishments = response);
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).affiliated_centers,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: establishments == null
              ? Center(child: Text('No Saved Products to Show'))
              : ListView.separated(
                  itemBuilder: (context, index) => EstablishmentCard(
                      establecimiento: establishments!.data[index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: establishments!.data.length),
        ),
      ),
    );
  }
}
