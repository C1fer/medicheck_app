import 'package:flutter/material.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:provider/provider.dart';
import '../models/cobertura.dart';
import '../models/notifiers/user_info_notifier.dart';
import '../screens/home/coverage/coverage_details.dart';
import 'cards/coverage_card.dart';

class CoveragesListView extends StatelessWidget {
  const CoveragesListView({
    super.key,
    required this.coverages,
  });

  final List<Cobertura> coverages;

  void saveRecentQuery(Cobertura cobertura, BuildContext context) async {
    if (cobertura == null || cobertura.idCobertura == null) return;

    print('Cobertura******: $cobertura');

    final userProvider = context.read<UserInfoModel>();
    int? userId = userProvider.currentUser?.idUsuario;

    if (userId == null) return;

    await ApiService.postRecentQuery(userId!, cobertura.idCobertura);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.separated(
        itemBuilder: (context, index) => CoverageCard(
          coverage: coverages[index],
          //onTap: () => Navigator.pushNamed(context, CoverageDetailView.id,
          //    arguments: coverages[index]),
          onTap: () async {
            saveRecentQuery(coverages[index], context);
            Navigator.pushNamed(context, CoverageDetailView.id, arguments: coverages[index]);
          },
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        itemCount: coverages.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
      ),
    );
  }
}
