import 'validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String? validateID (String? input, String documentType, BuildContext context){
  if (input != null){
    late bool _isValid;
    switch(documentType){
      case 'CEDULA':
        _isValid = Validators.isValidCedula(input!);
      case 'NSS':
        _isValid = Validators.isValidNSS(input!);
    }
    if (!_isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validateEmail (String? input, BuildContext context){
  if (input != null){
    bool _isValid = Validators.isValidEmail(input!);
    if (!_isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validatePassword (String? input, BuildContext context){
  if (input != null){
    bool _isValid = Validators.isValidPassword(input!);
    if (!_isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

String? validatePhoneNo (String? input, BuildContext context){
  if (input != null){
    bool _isValid = Validators.isValidPhone(input!);
    if (!_isValid) return AppLocalizations.of(context).invalid_input;
  }
  return null;
}

