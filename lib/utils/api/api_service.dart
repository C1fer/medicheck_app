import 'package:http/http.dart' as http;
import 'package:medicheck/models/establecimiento.dart';
import 'dart:convert';

import 'api_constants.dart';
import '../jwt_service.dart';
import 'package:medicheck/models/cobertura_grupo.dart';
import 'package:medicheck/models/cobertura_subgrupo.dart';
import 'package:medicheck/models/responses/cobertura_response.dart';
import 'package:medicheck/models/responses/plan_response.dart';
import 'package:medicheck/models/responses/incidente_response.dart';
import 'package:medicheck/models/responses/producto_response.dart';
import 'package:medicheck/models/tipo_producto.dart';
import '../../models/responses/establecimiento_response.dart';
import '../../models/usuario.dart';



class ApiService {
  // General methods
  static const Duration defaultTimeout = Duration(seconds: 5);
  static final Map<String, String> noAuthHeaders = {
    'Content-Type': 'application/json'
  };

  // Get request headers with jwt
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
        value == null ||
        value is String &&
            value.isEmpty); // Delete kv pairs with null values or empty strings
    params
        .updateAll((key, value) => value.toString()); // Parse all values as str
    return params;
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

  // User Methods
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
      print('User Login error: $e');
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
      print('User signup error: $e');
    }
    return null;
  }

  static Future<bool?> changeUserPassword(
      int userID, String currentPwd, String newPwd) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.changePasswordEndpoint);

    //Map body arguments
    Map<String, dynamic> requestBody = {
      'idUsuario': userID,
      'claveActual': currentPwd,
      'nuevaClave': newPwd
    };

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .put(url, headers: requestHeaders, body: json.encode(requestBody))
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      } catch (except) {
        print('Error changing password: $except');
      }
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
      {String? type,
      String? keyword,
      int? arsID,
      int? pageIndex,
      int? pageSize,
      String? orderField,
      String? orderDirection}) async {
    Map<String, dynamic> querParams = filterQueryParameters({
      "tipo": type,
      "search": keyword,
      "pageIndex": pageIndex,
      "pageSize": pageSize,
      "orderField": orderField,
      "orderDirection": orderDirection
    });

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.establishmentsInsurerEndpoint + '/$arsID')
        .replace(queryParameters: querParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return EstablecimientoResponse.fromJson(responseData);
        }
      } catch (except) {
        print('Error retrieving establishments: $except');
      }
    }
    return null;
  }

  static Future<ProductoResponse?> getSavedProducts(
      {int? userID, int? pageIndex, int? pageSize}) async {
    final Map<String, dynamic> queryParams = filterQueryParameters(
        {"idUsuario": userID, "pageIndex": pageIndex, "pageSize": pageSize});

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.savedProductsEndpoint)
            .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return ProductoResponse.fromJson(responseData);
        }
      } catch (except) {
        print('Error retrieving saved coverages: $except');
      }
    }

    return null;
  }

  static Future<CoberturaResponse?> getCoveragesAdvanced(int planID,
      {int? productID,
      int? userID,
      int? groupID,
      int? subGroupID,
      String? name,
      String? desc,
      String? type,
      int? pageIndex,
      int? pageSize,
      String? orderField,
      String? orderDirection}) async {
    Map<String, dynamic> queryParams = filterQueryParameters({
      'nombre': name,
      'tipo': type,
      'idPlan': planID,
      'idUsuario': userID,
      'idGrupo': groupID,
      'idSubgrupo': subGroupID,
      'idProducto': productID,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.coveragesSearchEndpoint)
            .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return CoberturaResponse.fromJson(responseData);
        }
      } catch (except) {
        print(except);
      }
    }
    return null;
  }

  static Future<bool> sendResetToken(String email) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.sendTokenEndpoint)
        .replace(queryParameters: {
      'emailAddress': email,
    });

    try {
      var response =
          await http.get(url, headers: noAuthHeaders).timeout(defaultTimeout);
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
      var response =
          await http.get(url, headers: noAuthHeaders).timeout(defaultTimeout);
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
    Map<String, dynamic> querParams =
        filterQueryParameters({'idUsuario': userID});

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.planEndpoint)
        .replace(queryParameters: querParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return PlanResponse.fromJson(responseData);
        }
      } catch (except) {
        print('Error retrieving plans: $except');
      }
    }

    return null;
  }

  static Future<bool> postSavedProduct(int userID, int productID) async {
    // Define API Endpoint
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.savedProductsEndpoint);

    //Map body arguments
    Map<String, int> requestBody = {
      'idUsuario': userID,
      'idProducto': productID
    };

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .post(
              url,
              body: json.encode(requestBody),
              headers: requestHeaders,
            )
            .timeout(defaultTimeout);

        if (response.statusCode == 201) {
          return true;
        }
      } catch (e) {
        print('Error posting saved product: $e');
      }
    }
    return false;
  }

  static Future<bool> deleteSavedProduct(int userID, int productID) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.savedProductsUserEndpoint}/$userID${ApiConstants.productEndpoint}/$productID');

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .delete(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 204) {
          return true;
        }
      } catch (except) {
        print('Error retrieving plans: $except');
      }
    }
    return false;
  }

  static Future<IncidenteResponse?> getIncidentReports(
      {int? userID,
      String? status,
      int? pageIndex,
      int? pageSize,
      String? keyword,
      String? orderField,
      String? orderDirection}) async {
    Map<String, dynamic> queryParams = filterQueryParameters({
      'idUsuario': userID,
      'estado': status,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'search': keyword,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.incidentsReportEndpoint)
            .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return IncidenteResponse.fromJson(responseData);
        }
      } catch (except) {
        print("Error fetching incidents: $except");
      }
    }
    return null;
  }

  static Future<bool> postNewIncidentReport(int userID, int planID,
      int establishmentID, int productID, String description) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.incidentsReportEndpoint);

    //Map body arguments
    Map<String, dynamic> requestBody = {
      "idUsuario": userID,
      "idPlan": planID,
      "descripcion": description,
      "idEstablecimiento": establishmentID,
      "idProducto": productID,
      "estado": "ABIERTO"
    };

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .post(url, headers: requestHeaders, body: json.encode(requestBody))
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          return true;
        }
      } catch (except) {
        print('Error creating incident report: $except');
      }
    }

    return false;
  }

  static Future<ProductoResponse?> getRecentQueries(
      {int? userId, int? planId, int? pageIndex, String? orderField}) async {
    Map<String, dynamic> queryParams = filterQueryParameters({
      'idUsuario': userId,
      'pageIndex': pageIndex,
      'orderField': orderField
    });

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.recentQueriesEndpoint)
            .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return ProductoResponse.fromJson(responseData);
        }
      } catch (except) {
        print('Exception: ${except.toString()}');
      }
    }
    return null;
  }

  static Future<bool> postRecentQuery(int userId, int productId) async {
    Map<String, dynamic> queryParams =
        filterQueryParameters({'idUsuario': userId, 'idProducto': productId});

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.recentQueriesEndpoint)
            .replace(queryParameters: filterQueryParameters(queryParams));

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .post(url, headers: requestHeaders)
            .timeout(defaultTimeout);

        if (response.statusCode == 201 || response.statusCode == 204) {
          // Coverage added or updated successfully
          return true;
        }
      } catch (e) {
        print('Post recent query request error: $e');
      }
    }
    return false;
  }

  static Future<List<GrupoCobertura>> getCoverageGroups() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.coverageGroupsEndpoint);

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData.map((e) => GrupoCobertura.fromJson(e)).toList();
        }
      } catch (except) {
        print('Error fetching coverage groups: ${except}');
      }
    }
    return <GrupoCobertura>[];
  }

  static Future<List<SubGrupoCobertura>> getCoverageSubGroups(
      int groupID) async {
    var url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.coverageSubGroupsEndpoint +
        '/$groupID');

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData
              .map((e) => SubGrupoCobertura.fromJson(e))
              .toList();
        }
      } catch (except) {
        print('Error fetching coverage subgroups: ${except}');
      }
    }
    return <SubGrupoCobertura>[];
  }

  static Future<List<TipoProducto>> getProductType() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.coverageTypeEndpoint);

    final Map<String, String>? requestHeaders = await getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData.map((e) => TipoProducto.fromJson(e)).toList();
        }
      } catch (except) {
        print('Error fetching product types: ${except}');
      }
    }
    return <TipoProducto>[];
  }

  static Future<ProductoResponse?> getProductsAdvanced(
      {String? name,
      String? filterCategory,
      int? planID,
      int? typeID,
      int? pageIndex,
      String? orderField,
      String? orderDirection}) async {
    // Set filter for product category
    bool? _searchPDSSOnly;
    switch (filterCategory) {
      case "PDSS":
        _searchPDSSOnly = true;
      case "COMP":
        _searchPDSSOnly = false;
      default:
        _searchPDSSOnly = null;
    }

    Map<String, dynamic> queryParams = filterQueryParameters({
      'nombre': name,
      'soloComplementario': _searchPDSSOnly,
      'idPlan': planID,
      'idTipo': typeID,
      'pageIndex': pageIndex,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.productSearchEndpoint)
            .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return ProductoResponse.fromJson(responseData);
        }
      } catch (except) {
        print(except);
      }
    }
    return null;
  }

  static Future<List<dynamic>> getNearbyEstablishments(
      double lat, double lon, {int? planID,
        int? pageIndex,
        int? pageSize,
        String? orderField,
        String? orderDirection}) async {
    Map<String, dynamic> queryParams = filterQueryParameters({
      'idPlan': planID,
      'latitud': lat,
      'longitud': lon,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    var url =
    Uri.parse(ApiConstants.baseUrl + ApiConstants.establishmentsEndpoint)
        .replace(queryParameters: queryParams);

    final Map<String, String>? requestHeaders = await getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(defaultTimeout);
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body) as List;
          return responseData;
        }
      } catch (except) {
        print("Error fetching nearby establishments: $except");
      }
    }
    return [];
  }



}
