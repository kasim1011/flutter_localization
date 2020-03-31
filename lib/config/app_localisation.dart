import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const rtlLanguages = [
  'ar',
  'he',
  'fa',
];

const supportedLocales = [
  const Locale('en'),
  const Locale('es'),
  const Locale('ar'),
  const Locale('pt', 'br'),
];

class AppLocalisation {
  final Locale locale;
  Map<String, String> strings = <String, String>{};

  AppLocalisation(this.locale);

  static AppLocalisation of(BuildContext context) {
    return Localizations.of<AppLocalisation>(context, AppLocalisation);
  }

  static Future<AppLocalisation> load(Locale locale) async {
    String jsonContent = await rootBundle.loadString(
      'i18n/$locale.json',
    );
    if (jsonContent == null || jsonContent.isEmpty) {
      jsonContent = '{}';
    }
    final Map<String, dynamic> jsonDecoded = jsonDecode(jsonContent);
    final Map<String, String> strings = jsonDecoded.cast<String, String>();
    AppLocalisation translations = AppLocalisation(locale)..strings = strings;
    return translations;
  }

  String get currentLanguage => locale.languageCode;

  String get title {
    return strings['title'];
  }
}

class AppLocalisationDelegate extends LocalizationsDelegate<AppLocalisation> {
  final Locale overriddenLocale;

  const AppLocalisationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<AppLocalisation> load(Locale locale) {
    return AppLocalisation.load(overriddenLocale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalisation> old) => true;
}
