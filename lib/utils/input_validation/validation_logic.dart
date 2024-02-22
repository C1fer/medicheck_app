import 'validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? validateID (String? input, String documentType){
  if (input != null){
    late bool _isValid;
    switch(documentType){
      case 'CEDULA':
        _isValid = Validators.isValidCedula(input!);
      case 'NSS':
        _isValid = Validators.isValidNSS(input!);
    }
    if (!_isValid) return 'Invalid input';
  }
  return null;
}

String? validateEmail (String? input){
  if (input != null){
    bool _isValid = Validators.isValidEmail(input!);
    if (!_isValid) return 'Invalid input';
  }
  return null;
}

String? validatePassword (String? input){
  if (input != null){
    bool _isValid = Validators.isValidPassword(input!);
    if (!_isValid) return 'Invalid password';
  }
  return null;
}

String? validatePhoneNo (String? input){
  if (input != null){
    bool _isValid = Validators.isValidPhone(input!);
    if (!_isValid) return 'Invalid phone number';
  }
  return null;
}

