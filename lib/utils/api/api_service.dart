import 'package:http/http.dart' as http;
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'dart:convert';
import '../../models/producto.dart';
import '../../models/usuario.dart';
import 'api_constants.dart';
import '../jwt_service.dart';

class ApiService {
  static Future<Map<String, dynamic>?> UserLogin(
      String docNumber, String docType, String pwd) async {
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

      if (response.statusCode == 200 || response.statusCode == 401) {
        // Handle successful login
        Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        return responseData;
      }
    } catch (e) {
      print('Request error: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> UserSignup(
      String docNumber, String docType, String pwd, String email, String phoneNo) async {
    // Define API Endpoint
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.signUpEndpoint);

    //Map body arguments
    Map<String, String> signUpCredentials = {
      'noDocumento': docNumber,
      'tipoDocumento': docType,
      'clave': pwd,
      'rol': 'AFILIADO',
      'correo': email,
      'telefono': phoneNo
    };

    try {
      var response = await http.post(
        url,
        body: json.encode(signUpCredentials),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        // Handle successful login
        Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }
    } catch (e) {
      print('Request error: $e');
    }
    return null;
  }

  static Future<Usuario?> getUserById(String id) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id');

    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Usuario.fromJson(responseData);
      }
    } catch (except) {
      print('Error retrieving user: $except');
    }
    return null;
  }

  static Future<List<Establecimiento>> getEstablishments() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.establishmentsEndpoint);
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData
            .map((data) => Establecimiento.fromJson(data))
            .toList();
      }
    } catch (except) {
      print('Error retrieving establishments: $except');
    }
    return <Establecimiento>[];
  }

  static Future<List<Producto>> getSavedProductsbyUserID(int userID) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.savedProductsUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Producto.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Producto>[];
  }

  static Future<List<Cobertura>> getCoveragesbyUserID(String userID) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coveragesUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Cobertura>[];
  }

  static Future<List<Cobertura>> getCoveragesbyPlanProduct(int planID, int productID) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coveragesEndpoint}/plan/$planID/producto/$productID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Cobertura>[];
  }

  static Future<List<Cobertura>> getCoveragesAdvanced(
      String? name, String? desc, String? type, String? category) async {
    var url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coveragesEndpoint}')
            .replace(queryParameters: {
      'name': name,
      'desc': desc,
      'type': type,
      'category': category,
    });
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print(except);
    }
    return <Cobertura>[];
  }
}
