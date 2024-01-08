import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/usuario.dart';
import 'api_constants.dart';
import '../jwt_service.dart';

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

  static Future<Usuario?> getUserById(String id) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint + '/$id');

    String? accessToken = await JWTService.readJWT();

    try{
      var response = await http.get(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'});
      if (response.statusCode ==200){
        print(response.body);
        final Map<String, dynamic > responseData = json.decode(response.body);
        return Usuario.fromJson(responseData);
      }
      return null;
    }
    catch(except){
      print(except);
    }
  }

}
