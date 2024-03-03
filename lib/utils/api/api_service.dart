import 'package:http/http.dart' as http;
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'dart:convert';
import '../../models/plan.dart';
import '../../models/producto.dart';
import '../../models/usuario.dart';
import 'api_constants.dart';
import '../jwt_service.dart';

class ApiService {
  static Future<Map<String, dynamic>?> userLogin(
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
      ).timeout(const Duration(seconds: 5));

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

  static Future<Map<String, dynamic>?> userSignup(String docNumber,
      String docType, String pwd, String email, String phoneNo) async {
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
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 400) {
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

  static Future<Usuario?> getUserById(int userID) async {
    var url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$userID');

    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
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
      }).timeout(const Duration(seconds: 5));
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
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.savedProductsUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
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
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.coveragesUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Cobertura>[];
  }

  static Future<List<Cobertura>> getCoveragesbyPlanProduct(
      int planID, int productID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.coveragesEndpoint}/plan/$planID/producto/$productID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Cobertura>[];
  }

  static Future<List<Cobertura>> getCoveragesAdvanced(int selectedPlanID, {String? name, String? desc, String? type, String? category}) async {

    Map<String, dynamic> queryParams = {
      'nombre': name,
      'descripcion': desc,
      'tipo': type,
      'categoria': category,
      'idPlan': selectedPlanID.toString(),
    };

    var url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.coveragesSearchEndpoint}')
            .replace(queryParameters: queryParams );
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print(except);
    }
    return <Cobertura>[];
  }

  static Future<bool> sendResetToken(String email) async {
    var url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sendTokenEndpoint}')
            .replace(queryParameters: {
      'emailAddress': email,
    });

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 202) return true;
    } catch (except) {
      print('Error generating token $except');
    }
    return false;
  }

  static Future<bool> validateResetToken(String token, String emailAddr) async {
    Map<String, String> reqParams = {'token': token, 'emailAdress': emailAddr};

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.validateTokenEndpoint)
            .replace(queryParameters: reqParams);

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) return true;
    } catch (except) {
      print('Error validating token $except');
    }
    return false;
  }

  static Future<bool> resetPassword(
      String token, String newPass, String emailAddr) async {
    Map<String, String> reqParams = {
      'token': token,
      'newPassword': newPass,
      'emailAddress': emailAddr,
    };

    // Define API Endpoint
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.resetPasswordEndpoint)
            .replace(queryParameters: reqParams);

    try {
      var response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) return true;
    } catch (except) {
      print('Error resetting password : $except');
    }
    return false;
  }

  static Future<List<Plan>> getPlansbyUserID(int userID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.planUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        var x =  responseData.map((data) => Plan.fromJson(data)).toList();
        return x;
      }
    } catch (except) {
      print('Error retrieving plans: $except');
    }
    return <Plan>[];
  }

}
