import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_utils.dart';
import 'api_constants.dart';

import '../../models/cobertura_grupo.dart';
import '../../models/cobertura_subgrupo.dart';
import '../../models/responses/cobertura_response.dart';
import '../../models/responses/plan_response.dart';
import '../../models/responses/incidente_response.dart';
import '../../models/responses/producto_response.dart';
import '../../models/tipo_producto.dart';
import '../../models/responses/establecimiento_response.dart';
import '../../models/usuario.dart';

class ApiService {
  static Future<bool> checkHealth() async {
    final Uri url = await ApiUtils.getParsedUri(ApiConstants.health);
    try {
      var response = await http
          .get(url, headers: ApiConstants.noAuthHeaders)
          .timeout(ApiConstants.defaultTimeout);
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
    final Uri url = await ApiUtils.getParsedUri(ApiConstants.loginEndpoint);
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
            headers: ApiConstants.noAuthHeaders,
          )
          .timeout(ApiConstants.defaultTimeout);

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
    final Uri url = await ApiUtils.getParsedUri(ApiConstants.signUpEndpoint);
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
            headers: ApiConstants.noAuthHeaders,
          )
          .timeout(ApiConstants.defaultTimeout);

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
    final Uri url =
        await ApiUtils.getParsedUri(ApiConstants.changePasswordEndpoint);
    //Map body arguments
    Map<String, dynamic> requestBody = {
      'idUsuario': userID,
      'claveActual': currentPwd,
      'nuevaClave': newPwd
    };

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .put(url, headers: requestHeaders, body: json.encode(requestBody))
            .timeout(ApiConstants.defaultTimeout);
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
    final Uri url =
        await ApiUtils.getParsedUri('${ApiConstants.usersEndpoint}/$userID');

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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

  static Future<EstablecimientoResponse?> getEstablishments(int arsID,
      {String? type,
      String? keyword,
      int? pageIndex,
      int? pageSize,
      String? orderField,
      String? orderDirection}) async {
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
      "tipo": type,
      "search": keyword,
      "pageIndex": pageIndex,
      "pageSize": pageSize,
      "orderField": orderField,
      "orderDirection": orderDirection
    });

    final Uri url = await ApiUtils.getParsedUri(
        '${ApiConstants.establishmentsInsurerEndpoint}/$arsID',
        queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
      {int? userID, int? productID, int? pageIndex, int? pageSize}) async {
    final Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters(
        {"idUsuario": userID, "idProducto": productID, "pageIndex": pageIndex, "pageSize": pageSize});

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.savedProductsEndpoint,
        queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
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

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.coveragesSearchEndpoint,
        queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    final Uri url = await ApiUtils.getParsedUri(ApiConstants.sendTokenEndpoint,
        queryParams: {
          'emailAddress': email,
        });

    try {
      var response = await http
          .get(url, headers: ApiConstants.noAuthHeaders)
          .timeout(ApiConstants.defaultTimeout);
      if (response.statusCode == 202) return true;
    } catch (except) {
      print('Error generating token $except');
    }
    return false;
  }

  static Future<bool> validateResetToken(String token, String emailAddr) async {
    Map<String, String> requestParams = {
      'token': token,
      'emailAdress': emailAddr
    };

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.validateTokenEndpoint,
        queryParams: requestParams);

    try {
      var response = await http
          .get(url, headers: ApiConstants.noAuthHeaders)
          .timeout(ApiConstants.defaultTimeout);
      if (response.statusCode == 200) return true;
    } catch (except) {
      print('Error validating token $except');
    }
    return false;
  }

  static Future<bool> resetPassword(
      String token, String newPass, String emailAddr) async {
    Map<String, String> requestParams = {
      'token': token,
      'newPassword': newPass,
      'emailAddress': emailAddr,
    };

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.resetPasswordEndpoint,
        queryParams: requestParams);
    // Define API Endpoint
    try {
      var response = await http
          .patch(
            url,
            headers: ApiConstants.noAuthHeaders,
          )
          .timeout(ApiConstants.defaultTimeout);
      if (response.statusCode == 200) return true;
    } catch (except) {
      print('Error resetting password : $except');
    }
    return false;
  }

  static Future<PlanResponse?> getPlansbyUserID(int userID) async {
    Map<String, dynamic> requestParams =
        ApiUtils.filterQueryParameters({'idUsuario': userID});

    final Uri url = await ApiUtils.getParsedUri(ApiConstants.planEndpoint,
        queryParams: requestParams);

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    final Uri url =
        await ApiUtils.getParsedUri(ApiConstants.savedProductsEndpoint);

    //Map body arguments
    Map<String, int> requestBody = {
      'idUsuario': userID,
      'idProducto': productID
    };

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .post(
              url,
              body: json.encode(requestBody),
              headers: requestHeaders,
            )
            .timeout(ApiConstants.defaultTimeout);

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
    final Uri url = await ApiUtils.getParsedUri(
        '${ApiConstants.savedProductsUserEndpoint}/$userID${ApiConstants.productEndpoint}/$productID');

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .delete(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
      'idUsuario': userID,
      'estado': status,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'search': keyword,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.incidentsReportEndpoint,
        queryParams: requestParams);

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    final Uri url =
        await ApiUtils.getParsedUri(ApiConstants.incidentsReportEndpoint);

    //Map body arguments
    Map<String, dynamic> requestBody = {
      "idUsuario": userID,
      "idPlan": planID,
      "descripcion": description,
      "idEstablecimiento": establishmentID,
      "idProducto": productID,
      "estado": "ABIERTO"
    };

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .post(url, headers: requestHeaders, body: json.encode(requestBody))
            .timeout(ApiConstants.defaultTimeout);
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
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
      'idUsuario': userId,
      'idPlan': planId,
      'pageIndex': pageIndex,
      'orderField': orderField
    });

    final Uri url = await ApiUtils.getParsedUri(ApiConstants.recentQueriesEndpoint, queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters(
        {'idUsuario': userId, 'idProducto': productId});

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.recentQueriesEndpoint,
        queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .post(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);

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
    final Uri url =
        await ApiUtils.getParsedUri(ApiConstants.coverageGroupsEndpoint);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData.map((e) => GrupoCobertura.fromJson(e)).toList();
        }
      } catch (except) {
        print('Error fetching coverage groups: $except');
      }
    }
    return <GrupoCobertura>[];
  }

  static Future<List<SubGrupoCobertura>> getCoverageSubGroups(
      int groupID) async {
    final Uri url = await ApiUtils.getParsedUri(
        '${ApiConstants.coverageSubGroupsEndpoint}/$groupID');
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData
              .map((e) => SubGrupoCobertura.fromJson(e))
              .toList();
        }
      } catch (except) {
        print('Error fetching coverage subgroups: $except');
      }
    }
    return <SubGrupoCobertura>[];
  }

  static Future<List<TipoProducto>> getProductType() async {
    final Uri url =
        await ApiUtils.getParsedUri(ApiConstants.coverageTypeEndpoint);

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();

    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
        if (response.statusCode == 200) {
          final List responseData = json.decode(response.body) as List;
          return responseData.map((e) => TipoProducto.fromJson(e)).toList();
        }
      } catch (except) {
        print('Error fetching product types: $except');
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
    bool? searchPDSSOnly;
    switch (filterCategory) {
      case "PDSS":
        searchPDSSOnly = false;
      case "COMP":
        searchPDSSOnly = true;
      default:
        searchPDSSOnly = null;
    }

    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
      'nombre': name,
      'soloComplementario': searchPDSSOnly,
      'idPlan': planID,
      'idTipo': typeID,
      'pageIndex': pageIndex,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.productSearchEndpoint,
        queryParams: requestParams);

    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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

  static Future<List<dynamic>> getNearbyEstablishments(double lat, double lon,
      {int? planID,
      int? pageIndex,
      int? pageSize,
      String? orderField,
      String? orderDirection}) async {
    Map<String, dynamic> requestParams = ApiUtils.filterQueryParameters({
      'idPlan': planID,
      'latitud': lat,
      'longitud': lon,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'orderField': orderField,
      'orderDirection': orderDirection,
    });

    final Uri url = await ApiUtils.getParsedUri(
        ApiConstants.establishmentsEndpoint,
        queryParams: requestParams);
    final Map<String, String>? requestHeaders = await ApiUtils.getAuthHeaders();
    if (requestHeaders != null) {
      try {
        var response = await http
            .get(url, headers: requestHeaders)
            .timeout(ApiConstants.defaultTimeout);
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
