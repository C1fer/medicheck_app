import 'validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String? validateID(String? input, String documentType, BuildContext context) {
  if (input != null) {
    late bool isValid;
    switch (documentType) {
      case 'CEDULA':
        isValid = Validators.isValidCedula(input);
      case 'NSS':
        isValid = Validators.isValidNSS(input);
    }
    if (!isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validateEmail(String? input, BuildContext context) {
  if (input != null) {
    bool isValid = Validators.isValidEmail(input);
    if (!isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validatePassword(String? input, BuildContext context) {
  if (input != null) {
    bool isValid = Validators.isValidPassword(input);
    if (!isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validateConfirmPassword(
    String? pass1, String? pass2, BuildContext context) {
  if (pass1 != null && pass2 != null) {
    bool isValid = pass1 == pass2;
    if (!isValid) return AppLocalizations.of(context).pwd_not_matching;
  }
  return null;
}

String? validatePhoneNo(String? input, BuildContext context) {
  if (input != null) {
    bool isValid = Validators.isValidPhone(input);
    if (!isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validateResetTokenInput(String? input, BuildContext context) {
  if (input != null) {
    bool isValid = Validators.isValidResetToken(input);
    if (!isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validateEmptyInput(String? input, BuildContext context){
  if (input == null || input == ''){
    return AppLocalizations.of(context).empty_value_constraint;
  }
  return null;
}

String? validateAutoComplete(String? input, String? ref, TextEditingController controller, BuildContext context){
  if (input == '' || input == null || input != ref){
    controller.clear();
    return AppLocalizations.of(context).invalid_input;
  }
  return null;
}
