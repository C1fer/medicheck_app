import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'package:medicheck/models/notifiers/localeNotifier.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:medicheck/utils/api/api_service.dart';
import 'package:medicheck/widgets/cards/place_card.dart';
import 'package:medicheck/widgets/misc/data_loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../models/google_place.dart';
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
    super.initState();
  }

  Future<List<GooglePlace>> _getNearbyPlaces() async {
    try {
      Position location = await GeolocationService.getCurrentPosition();
      final response = await ApiService.getNearbyEstablishments(location.latitude, location.longitude);

      if (response.isNotEmpty) {
        List<GooglePlace> nearbyPlaces = [];
        for (Map<String, dynamic> json in response){
            final establishment = Establecimiento.fromJson(json["establecimiento"]);
            final placeResponse = await PlacesApiService.getPlaceById(establishment.googlePlaceID);
            if (placeResponse != null){
              // Create new Google Place from Places Detail response
              final photoUri = placeResponse["photos"] != null ? placeResponse["photos"][0]["name"] : null;
              final String rating = placeResponse["rating"].toString();
              GooglePlace place = GooglePlace(establishment, photoUri, double.parse(rating), json["distancia"]);
              nearbyPlaces.add(place);
            }
        }
        return nearbyPlaces;
      }
    } catch (ex) {
     print("Error fetching places: $ex");
    }
    return Future.error("");
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
              future: _getNearbyPlaces(),
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
                                  snapshot.data![idx], 600, 600)),
                        separatorBuilder: (context, idx) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshot.data!.length);
                  }
                }
                return Expanded(
                  child: const Center(
                      child: DataLoadingIndicator()),
                );
              },
            ),
          ),
        ));
  }
}
