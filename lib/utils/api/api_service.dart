import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_constants.dart';

class ApiService {
  static Future<Map<String, dynamic>?> UserLogin(String docNumber, String docType, String pwd) async {
    // Define API Endpoint
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);

    //Map body arguments
    Map<String, String> loginCredentials = {
      'noDocumento': docNumber,
      'tipoDocumento': docType,
      'clave': pwd
    };

    try {
      var response = await http.post(
        url,
        body: json.encode(loginCredentials),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Handle successful login
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }
      else {
        // Handle unsuccessful login (e.g., wrong credentials, server error)
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Request error: $e');
    }
  }
}
