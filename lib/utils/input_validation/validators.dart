class Validators {
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  static bool isValidName(String name) {
    final nameRegExp =
    RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(name);
  }

  static bool isValidPassword(String password) {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  static bool isNotNull(String value) {
    return value != null;
  }

  static bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(r"^[0-9]\d{9}$");
    return phoneRegExp.hasMatch(phone);
  }

  static bool isValidCedula(String cedula) {
    final phoneRegExp = RegExp(r"^[0-9]\d{10}$");
    return phoneRegExp.hasMatch(cedula);
  }

  static bool isValidNSS(String nss) {
    final phoneRegExp = RegExp(r"^[0-9]\d{8}$");
    return phoneRegExp.hasMatch(nss);
  }

}
