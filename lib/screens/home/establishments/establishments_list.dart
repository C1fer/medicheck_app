import 'package:flutter/material.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../utils/api/api_service.dart';
import '../../../models/establecimiento.dart';
import '../../../widgets/cards/establishment_card.dart';

class EstablishmentsList extends StatefulWidget {
  const EstablishmentsList({super.key});
  static const String id = 'establishments_list';

  @override
  State<EstablishmentsList> createState() => _EstablishmentsListState();
}

class _EstablishmentsListState extends State<EstablishmentsList> {
  late List<Establecimiento>? establishments = [];

  @override
  void initState() {
    super.initState();
    _getEstablishments();
  }

  void _getEstablishments() async {
    try {
      var response = await ApiService.getEstablishments();
      if (mounted) {
        setState(() => establishments = response);
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getEstablishments();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Centros afiliados',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
              itemBuilder: (context, index) =>
                  EstablishmentCard(establecimiento: establishments![index]),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: establishments!.length),
        ),
      ),
    );
  }
}
