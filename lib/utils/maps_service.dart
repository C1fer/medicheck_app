import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/google_place.dart';

class PlacesApiService {
  static const apiKey = "AIzaSyBF4HkTwIaYTIXubPpfRc2v7vKOMRgs3pw ";
  static const baseUrl = "https://places.googleapis.com/v1";
  static const placesEndpoint = "/places";
  static const mediaEndpoint = "/:placeUri/media";
  static const defaultTimeout = Duration(seconds: 5);


  static Future<Map<String,dynamic>?> getPlaceById(String placeID) async{
    List<String> returnFields = ["photos","rating"];

    Map<String, String> queryParams = {
      "key": apiKey,
      "languageCode": "es",
      "fields": returnFields.join(",")
    };

    final url = Uri.parse("$baseUrl$placesEndpoint/$placeID").replace(queryParameters: queryParams);
    try {
      var response = await http
          .get(url, headers: {"Content-Type": "application/json"})
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }
    } catch (except) {
      print("Error fetching place: $except");
    }
    return null;
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
