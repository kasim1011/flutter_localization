import 'dart:async';
import 'dart:developer' show log;

import 'package:action_broadcast/action_broadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localizationdemo/config/app_localisation.dart';
import 'package:localizationdemo/config/const.dart';
import 'package:localizationdemo/config/locale_prefs.dart';
import 'package:localizationdemo/ui/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale savedLocale = await LocalePrefs().currentLocale();
  return runApp(App(savedLocale));
}

class App extends StatefulWidget {
  final Locale savedLocale;

  App(this.savedLocale, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  var _initStateFlag = false;
  AppLocalisationDelegate _localeOverrideDelegate;
  StreamSubscription _receiver;

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) {
      log('initState', name: '_AppState::initState');
    }
    _initStateFlag = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kReleaseMode) {
      log('didChangeDependencies', name: '_AppState::didChangeDependencies');
    }
    if (_initStateFlag) {
      _initStateFlag = false;
      _localeOverrideDelegate =
          AppLocalisationDelegate(widget.savedLocale ?? supportedLocales[0]);

      _receiver =
          registerReceiver([Const.actionLocale]).listen((ActionIntent intent) {
        if (!kReleaseMode) {
          log('registerReceiver', name: '_AppState::registerReceiver');
        }

        final locale = intent?.data;
        if (!(locale is Locale)) {
          return;
        }

        if (!kReleaseMode) {
          log('locale is $locale', name: '_AppState::registerReceiver');
        }
        setState(() {
          _localeOverrideDelegate = AppLocalisationDelegate(locale);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
      log('build', name: '_AppState::build');
    }
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateTitle: (BuildContext context) {
        log('onGenerateTitle', name: '_AppState::onGenerateTitle');
        return AppLocalisation.of(context).title;
      },
      localizationsDelegates: [
        _localeOverrideDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
        textDirection: rtlLanguages.contains(
          _localeOverrideDelegate.overriddenLocale.languageCode,
        )
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: HomePage(),
      ),
    );
  }

  @override
  void dispose() {
    _receiver?.cancel();
    super.dispose();
  }
}
