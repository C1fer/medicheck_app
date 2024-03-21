import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:medicheck/models/notifiers/localeNotifier.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/widgets/cards/place_card.dart';
import 'package:provider/provider.dart';
import '../../../models/place.dart';
import '../../../widgets/misc/custom_appbar.dart';
import '../../../utils/location_service.dart';
import '../../../utils/maps_service.dart';

class NearbyCenters extends StatefulWidget {
  const NearbyCenters({super.key});

  static const String id = "nearby_centers";

  @override
  State<NearbyCenters> createState() => _NearbyCentersState();
}

class _NearbyCentersState extends State<NearbyCenters> {
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<List<GooglePlace>> _fetchData() async {
    try {
      Position location = await GeolocationService.getCurrentPosition();
      String localeLangCode = context.read<LocaleModel>().locale.languageCode;
      final places = await PlacesApiService.nearbySearch(
          18.474125, -69.975324, localeLangCode);
      return places;
    } catch (ex) {
      return Future.error("Error fetching places");
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
        appBar: CustomAppBar(
          title: locale.near_centers,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text(locale.no_results_shown),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.separated(
                        itemBuilder: (context, idx) => PlaceCard(
                              place: snapshot.data![idx],
                              placePhotoURL: PlacesApiService.getPlacePhotoUri(
                                  snapshot.data![idx], 100, 100),
                              onTap: () => MapsLauncher.launchCoordinates(
                                  snapshot.data![idx].lat,
                                  snapshot.data![idx].lon),
                            ),
                        separatorBuilder: (context, idx) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshot.data!.length);
                  }
                }
                return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                  color: AppColors.jadeGreen,
                )));
              },
            ),
          ),
        ));
  }
}
