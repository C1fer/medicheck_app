import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleModel extends ChangeNotifier {
  Locale _locale = setInitLocale();

  Locale get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

Locale setInitLocale() {
  final osLocale = Locale(Intl.shortLocale(Intl.getCurrentLocale())); // Get OS locale

  Locale? osLocaleSupported = AppLocalizations.supportedLocales
      .firstWhere((locale) => osLocale.languageCode == locale.languageCode);

  if (osLocaleSupported != null) {
    return osLocale; // Use system locale if supported
  } else {
    //  Use fallback locale if system locale is unsupported
    Locale fallbackLocale = AppLocalizations.supportedLocales.first;
    return fallbackLocale;
  }
}