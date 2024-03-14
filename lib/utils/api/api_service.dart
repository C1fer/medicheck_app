import 'package:http/http.dart' as http;
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/models/cobertura_response.dart';
import 'package:medicheck/models/establecimiento.dart';
import 'package:medicheck/models/plan_response.dart';
import 'package:medicheck/models/responses/incident_response.dart';
import 'dart:convert';
import '../../models/establecimiento_response.dart';
import '../../models/plan.dart';
import '../../models/producto.dart';
import '../../models/usuario.dart';
import 'api_constants.dart';
import '../jwt_service.dart';

class ApiService {
  static final Duration defaultTimeout = Duration(seconds: 5);
  static final Map<String, String> noAuthHeaders = {
    'Content-Type': 'application/json'
  };

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

  static Future<bool> checkHealth() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.health);
    try {
      var response =
          await http.get(url, headers: noAuthHeaders).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (except) {
      print("Can't reach server");
    }
    return false;
  }

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
      var response = await http
          .post(
            url,
            body: json.encode(loginCredentials),
            headers: noAuthHeaders,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200 || response.statusCode == 401) {
        // Handle successful login
        return json.decode(response.body);
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
      var response = await http
          .post(
            url,
            body: json.encode(signUpCredentials),
            headers: noAuthHeaders,
          )
          .timeout(defaultTimeout);

      if (response.statusCode == 200 || response.statusCode == 400) {
        // Handle successful login
        return json.decode(response.body);
      }
    } catch (e) {
      print('Request error: $e');
    }
    return null;
  }

  static Future<bool?> changeUserPassword(
      int userID, String currentPwd, String newPwd) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.changePasswordEndpoint);
    String? accessToken = await JWTService.readJWT();

    //Map body arguments
    Map<String, dynamic> requestBody = {
      'idUsuario': userID,
      'claveActual': currentPwd,
      'nuevaClave': newPwd
    };

    try {
      var response = await http
          .put(url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: json.encode(requestBody))
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (except) {
      print('Error changing password: $except');
      return null;
    }
  }

  static Future<Usuario?> getUserById(int userID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$userID');

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return Usuario.fromJson(responseData);
        }
      } catch (except) {
        print('Error retrieving user: $except');
      }
    }

    return null;
  }

  static Future<EstablecimientoResponse?> getEstablishments(
      {String? type, String? keyword, int? arsID}) async {
    Map<String, dynamic> querParams = {"tipo": type, "search": keyword};
    var url = Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.establishmentsInsurerEndpoint}/$arsID')
        .replace(queryParameters: querParams);
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return EstablecimientoResponse.fromJson(responseData);
      }
    } catch (except) {
      print('Error retrieving establishments: $except');
    }
    return null;
  }

  static Future<List<Producto>> getSavedProductsbyUserID(int userID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.savedProductsUserEndpoint}/$userID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
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
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((data) => Cobertura.fromJson(data)).toList();
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return <Cobertura>[];
  }

  static Future<CoberturaResponse?> getCoveragebyPlanProduct(
      int planID, int productID) async {
    Map<String, dynamic> reqParams = {
      "idPlan": planID.toString(),
      "idProducto": productID.toString()
    };

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.coveragesSearchEndpoint)
            .replace(queryParameters: reqParams);
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return CoberturaResponse.fromJson(responseData);
      }
    } catch (except) {
      print('Error retrieving coverages: $except');
    }
    return null;
  }

  static Future<CoberturaResponse?> getCoveragesAdvanced(int selectedPlanID,
      {String? name, String? desc, String? type, String? category}) async {
    Map<String, dynamic> queryParams = {
      'nombre': name,
      'descripcion': desc,
      'tipo': type,
      'categoria': category,
      'idPlan': selectedPlanID.toString(),
    };

    var url = Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.coveragesSearchEndpoint}')
        .replace(queryParameters: queryParams);
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return CoberturaResponse.fromJson(responseData);
      }
    } catch (except) {
      print(except);
    }
    return null;
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
      }).timeout(defaultTimeout);
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
      }).timeout(defaultTimeout);
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
      var response = await http
          .patch(
            url,
            headers: noAuthHeaders,
          )
          .timeout(defaultTimeout);
      if (response.statusCode == 200) return true;
    } catch (except) {
      print('Error resetting password : $except');
    }
    return false;
  }

  static Future<PlanResponse?> getPlansbyUserID(int userID) async {
    Map<String, dynamic> querParams = {'idUsuario': userID.toString()};

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.planEndpoint)
        .replace(queryParameters: querParams);
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        var x = PlanResponse.fromJson(responseData);
        return x;
      }
    } catch (except) {
      print('Error retrieving plans: $except');
    }
    return null;
  }

  static Future<bool> postSavedProduct(int userID, int productID) async {
    // Define API Endpoint
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.savedProductsEndpoint);
    String? accessToken = await JWTService.readJWT();

    //Map body arguments
    Map<String, int> requestBody = {
      'idUsuario': userID,
      'idProducto': productID
    };

    try {
      var response = await http.post(
        url,
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      ).timeout(defaultTimeout);

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('Request error: $e');
    }
    return false;
  }

  static Future<bool> deleteSavedProduct(int userID, int productID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.savedProductsUserEndpoint}/$userID${ApiConstants.productEndpoint}/$productID');
    String? accessToken = await JWTService.readJWT();

    try {
      var response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 204) {
        return true;
      }
    } catch (except) {
      print('Error retrieving plans: $except');
    }
    return false;
  }

  static Future<ReporteResponse?> getIncidentReports(int userID) async {
    Map<String, dynamic> queryParams = {
      'idUsuario': userID.toString(),
    };

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.incidentsReportEndpoint)
        .replace(queryParameters: queryParams);

    String? accessToken = await JWTService.readJWT();
    try {
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }).timeout(defaultTimeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return ReporteResponse.fromJson(responseData);
      }
    } catch (except) {
      print(except);
    }
    return null;
  }

  static Future<bool> postNewIncidentReport(int userID, int planID,
      int establishmentID, int productID, String description) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.incidentsReportEndpoint);
    String? accessToken = await JWTService.readJWT();

    //Map body arguments
    Map<String, dynamic> requestBody = {
      "idUsuario": userID,
      "idPlan": planID,
      "descripcion": description,
      "idEstablecimiento": establishmentID,
      "idProducto": productID,
      "estado": "ABIERTO"
    };

    try {
      var response = await http
          .post(url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: json.encode(requestBody))
          .timeout(defaultTimeout);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (except) {
      print('Error creating incident report: $except');
    }
    return false;
  }
}
