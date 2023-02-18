import 'package:flutter/material.dart';
import 'package:menu_app/Languages/Localizations.dart';
import 'package:menu_app/extensions/key.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';

Future<Locale> setLocale(String languageCode) async {
  ApplicationKeys.instance.setStringValue(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode =
      await ApplicationKeys.instance.getStringValue(LAGUAGE_CODE);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case ARABIC:
      return Locale(ARABIC, "SA");
    default:
      return Locale(ENGLISH, 'SA');
  }
}

String getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context).translate(key);
}
