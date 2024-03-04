class ApiConstants{
  //static String baseUrl = "https://medicheck-api.azurewebsites.net";
  //static String baseUrl = "http://10.0.2.2:5280";
  static String baseUrl = "http://localhost:5280";
  static String loginEndpoint = "/Auth/Login";
  static String signUpEndpoint = "/register";
  static String usersEndpoint = "/usuarios";
  static String coveragesEndpoint = "/coberturas";
  static String coveragesSearchEndpoint = "/coberturas/busquedaavanzada";
  static String coveragesUserEndpoint = "/coberturas/usuario";
  static String establishmentsEndpoint = "/establecimientos";
  static String planEndpoint = "/planes";
  static String productEndpoint = "/productos";
  static String savedProductsUserEndpoint = "/productosguardados/usuario";
  static String sendTokenEndpoint = "/otp-send-email";
  static String validateTokenEndpoint = "/otp-validate";
  static String resetPasswordEndpoint = "/otp-reset-password";
  static String incidentsUserEndpoint = "/reportesincidentes/usuario";
  static String planUserEndpoint = "/planes/usuario";
}