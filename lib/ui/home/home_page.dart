import 'dart:developer' show log;

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localizationdemo/config/app_localisation.dart';
import 'package:localizationdemo/config/const.dart';
import 'package:localizationdemo/config/locale_prefs.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _strings = Map<String, String>();
  var _initStateFlag = false;

  var _languageValue = 0;
  Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) {
      log('initState', name: '_HomePageState::initState');
    }
    _initStateFlag = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kReleaseMode) {
      log('didChangeDependencies',
          name: '_HomePageState::didChangeDependencies');
    }
    if (_initStateFlag) {
      _initStateFlag = false;
      final appLocalisation = AppLocalisation.of(context);
      _strings = appLocalisation.strings;
      _currentLocale = appLocalisation.locale;
      _languageValue = supportedLocales.indexOf(_currentLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
      log('build', name: '_HomePageState::build');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _strings['title'],
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _strings['select_language'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Divider(),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio(
                      groupValue: _languageValue,
                      value: 0,
                      onChanged: _onLanguageChanged,
                    ),
                    Text(
                      _strings['lang_english'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio(
                      groupValue: _languageValue,
                      value: 1,
                      onChanged: _onLanguageChanged,
                    ),
                    Text(
                      _strings['lang_spanish'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio(
                      groupValue: _languageValue,
                      value: 2,
                      onChanged: _onLanguageChanged,
                    ),
                    Text(
                      _strings['lang_arabic'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio(
                      groupValue: _languageValue,
                      value: 3,
                      onChanged: _onLanguageChanged,
                    ),
                    Text(
                      _strings['brazilian_portuguese'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Divider(),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${_strings['current_locale']}: $_currentLocale',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLanguageChanged(Object value) async {
    if (!kReleaseMode) {
      log('value is $value', name: '_onLanguageChanged');
      log('value.runtimeType is ${value.runtimeType}',
          name: '_onLanguageChanged');
      if (!(value is int)) {
        return;
      }
      final newLocale = supportedLocales[value];
      await LocalePrefs().setLocale(newLocale);
      _initStateFlag = true;
      sendBroadcast(
        Const.actionLocale,
        data: newLocale,
      );
    }
  }
}
