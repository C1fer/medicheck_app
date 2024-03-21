import 'dart:convert';

import '../models/place.dart';
import '../models/place.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static const apiKey = "AIzaSyBF4HkTwIaYTIXubPpfRc2v7vKOMRgs3pw ";
  static const baseUrl = "https://places.googleapis.com/v1";
  static const searchNearbyEndpoint = "/places:searchNearby";
  static const defaultTimeout = Duration(seconds: 5);

  static Future<List<GooglePlace>> nearbySearch(
      double lat, double lon, String placeType, String langCode,
      {double? areaRadius, int? maxResultCount, String? rankPreference}) async {
    // Fields requested in header
    List<String> returnFields = [
      'places.nationalPhoneNumber',
      'places.internationalPhoneNumber',
      'places.formattedAddress',
      'places.displayName',
      'places.primaryTypeDisplayName',
      'places.currentOpeningHours',
      'places.primaryType',
      'places.shortFormattedAddress',
      'places.photos',
      'places.websiteUri'
    ];

    Map<String, dynamic> locationRestriction = {
      "circle": {
        "center": {"latitude": lat, "longitude": lon},
        "radius": areaRadius ?? 500
      }
    };

    Map<String, dynamic> requestBody = {
      "includedTypes": placeType,
      "maxResultCount": maxResultCount ?? 10,
      "languageCode": langCode,
      "rankPreference": rankPreference ?? "DISTANCE",
      "locationRestriction": locationRestriction
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": returnFields.join(",")
    };

    final url = Uri.parse(baseUrl + searchNearbyEndpoint);
    try {
      var response = await http
          .post(url, body: json.encode(requestBody), headers: requestHeaders)
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String,dynamic> responseData = json.decode(response.body);
        var x = responseData["places"].map((e) => GooglePlace.fromJson(e)).toList();
        return x;
      }
    } catch (except) {
      print("Error fetching nearby places: $except");
    }
    return <GooglePlace>[];
  }
}

void main() async {
  var response =
      await PlaceService.nearbySearch(18.474125, -69.975324, "pharmacy", "en");
  print(response);
}
