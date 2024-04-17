import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import '../jwt_service.dart';
import 'api_constants.dart';

class ApiUtils{

  // Get Base API Url for device
  static Future<String> setBaseUrl() async{
    final AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
    final bool isPhysicalDevice = deviceInfo.isPhysicalDevice;
    if (kDebugMode){
      // Point to local api
      return isPhysicalDevice ? ApiConstants.baseUrlPhysical : ApiConstants.baseUrlAVD ;
    }
    return ApiConstants.baseUrlHost; // Point to hosted api

  }

  // Get uri
  static Future<Uri> getParsedUri(String endpoint, {Map<String, dynamic>? queryParams}) async{
    final String baseUrl = await setBaseUrl();
    if (queryParams != null){
      return Uri.parse(baseUrl + endpoint).replace(queryParameters: queryParams);
    }
    return Uri.parse(baseUrl + endpoint);
  }

  // Get request headers with JSON Web Token
  static Future<Map<String, String>?> getAuthHeaders() async {
    String? accessToken = await JWTService.readJWT();

    if (accessToken != null) {
      final Map<String, String> authHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      };
      return authHeaders;
    }
    return null;
  }

  // Sanitize query parameters from request
  static Map<String, dynamic> filterQueryParameters(
      Map<String, dynamic> params) {
    params.removeWhere((key, value) =>
    value == null || value is String && value.isEmpty); // Delete kv pairs with null values or empty strings
    params
        .updateAll((key, value) => value.toString()); // Parse all values as str
    return params;
  }

}