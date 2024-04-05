import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/google_place.dart';

class PlacesApiService {
  static const apiKey = "AIzaSyBF4HkTwIaYTIXubPpfRc2v7vKOMRgs3pw ";
  static const baseUrl = "https://places.googleapis.com/v1";
  static const nearbySearchEndPoint = "/places:searchNearby";
  static const mediaEndpoint = "/:placeUri/media";
  static const defaultTimeout = Duration(seconds: 5);

  static Future<List<GooglePlace>> nearbySearch(
      double lat, double lon, String langCode,
      {double? areaRadius, int? maxResultCount, String? rankPreference, List<String>? placeTypes}) async {
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
      'places.websiteUri',
      'places.location',
      'places.id'
    ];

    List<String> primaryTypes = [
      "dental_clinic",
      "dentist",
      "doctor",
      "drugstore",
      "hospital",
      "medical_lab",
      "pharmacy",
      "physiotherapist"
    ];

    Map<String, dynamic> locationRestriction = {
      "circle": {
        "center": {"latitude": lat, "longitude": lon},
        "radius": areaRadius ?? 500
      }
    };

    Map<String, dynamic> requestBody = {
      "includedTypes": primaryTypes.toList(),
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

    final url = Uri.parse(baseUrl + nearbySearchEndPoint);
    try {
      var response = await http
          .post(url, body: json.encode(requestBody), headers: requestHeaders)
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> places = responseData["places"];
        return places.map((e) => GooglePlace.fromJson(e)).toList();
      }
    } catch (except) {
      print("Error fetching nearby places: $except");
    }
    return <GooglePlace>[];
  }

  static String? getPlacePhotoUri(
      GooglePlace place, int maxHeightPx, int maxWidthPx) {
    if (place.photoUri != null) {
      Map<String, String> queryParams = {
        "key": apiKey,
        "maxHeightPx": maxHeightPx.toString(),
        "maxWidthPx": maxWidthPx.toString()
      };

      return Uri.parse(
              baseUrl + mediaEndpoint.replaceAll(":placeUri", place.photoUri!))
          .replace(queryParameters: queryParams).toString();
    }
    return null;
  }
}
