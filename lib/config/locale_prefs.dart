import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePrefs {
  static const LocaleKey = 'LocaleKey';

  LocalePrefs();

  Future<Locale> currentLocale() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String localeString = preferences.getString(LocaleKey);
    if (localeString == null) {
      return null;
    }
    final stripes = localeString.split("_");
    switch (stripes.length) {
      case 1:
        return Locale(
          stripes[0],
        );
        break;
      case 2:
        return Locale(
          stripes[0],
          stripes[1],
        );
        break;
      default:
        return null;
        break;
    }
  }

  Future<bool> setLocale(Locale locale) async {
    if (locale == null) {
      return false;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(LocaleKey, locale.toString());
  }
}
