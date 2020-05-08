import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mmhelper/services/AppLanguage.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:flutter_mmhelper/ui/SelectLanguagePage.dart';
import 'package:provider/provider.dart';

import 'services/DataListService.dart';
import 'services/GetCountryListService.dart';
import 'services/callSearch.dart';
import 'services/database.dart';

void main() async {
  AppLanguage appLanguage = AppLanguage();
  WidgetsFlutterBinding.ensureInitialized();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Map<int, Color> color = {
    50: Color.fromRGBO( 194,156,33, .1),
    100: Color.fromRGBO(194,156,33, .2),
    200: Color.fromRGBO(194,156,33, .3),
    300: Color.fromRGBO(194,156,33, .4),
    400: Color.fromRGBO(194,156,33, .5),
    500: Color.fromRGBO(194,156,33, .6),
    600: Color.fromRGBO(194,156,33, .7),
    700: Color.fromRGBO(194,156,33, .8),
    800: Color.fromRGBO(194,156,33, .9),
    900: Color.fromRGBO(194,156,33, 1),
  };
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFbf9b30, color);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppLanguage>(
            create: (_) => appLanguage,
          ),
          ChangeNotifierProvider<GetCountryListService>(
            create: (_) => GetCountryListService(),
          ),
          ChangeNotifierProvider<FirestoreDatabase>(
            create: (_) => FirestoreDatabase(),
          ),
          ChangeNotifierProvider<DataListService>(
            create: (_) => DataListService(),
          ),
          ChangeNotifierProvider<CallSearch>(
            create: (_) => CallSearch(),
          ),
        ],
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: model.appLocal,
            title: "Search 4 Maid",
            supportedLocales: [
              Locale('en', 'US'),
              Locale('zh','CN'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            theme: ThemeData(primarySwatch: colorCustom),
            home: SelectLanguagePage(),
          );
        }));
  }
}
