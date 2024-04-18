class ApiConstants{
  // General methods
  static const Duration defaultTimeout = Duration(seconds: 5);
  static final Map<String, String> noAuthHeaders = {
    'Content-Type': 'application/json'
  };

  //Routes
  static String baseUrlHost = "https://medicheck-api.azurewebsites.net";
  static String baseUrlAVD = "http://10.0.2.2:5280";
  static String baseUrlPhysical = "http://localhost:5280";
  static String health = "/health";
  static String loginEndpoint = "/Auth/Login";
  static String signUpEndpoint = "/register";
  static String usersEndpoint = "/usuarios";
  static String coveragesEndpoint = "/coberturas";
  static String coveragesSearchEndpoint = "/coberturas/busquedaavanzada";
  static String coveragesUserEndpoint = "/coberturas/usuario";
  static String establishmentsEndpoint = "/establecimientos";
  static String establishmentsInsurerEndpoint = "/establecimientos/aseguradora";
  static String planEndpoint = "/planes";
  static String productsEndpoint = "/productos";
  static String productEndpoint = "/producto";
  static String savedProductsUserEndpoint = "/productosguardados/usuario";
  static String savedProductsEndpoint = "/productosguardados";
  static String sendResetTokenEndpoint = "/otp-send-email";
  static String validateResetTokenEndpoint = "/otp-validate";
  static String resetPasswordEndpoint = "/otp-reset-password";
  static String incidentsReportEndpoint = "/reportesincidentes/";
  static String changePasswordEndpoint = "/usuarios/cambiarclave";
  static String recentQueriesEndpoint = "/consultasrecientes";
  static String coverageTypeEndpoint = "/tipocobertura";
  static String coverageGroupsEndpoint = "/grupos";
  static String coverageSubGroupsEndpoint = "/subgrupos";
  static String productSearchEndpoint = "/productos/busquedaavanzada";
  static String sendConfirmTokenEndpoint = "/otp-send-email";
  static String validateConfirmTokenEndpoint = "/otp-validate";
}