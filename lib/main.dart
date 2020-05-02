import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mmhelper/services/AppLanguage.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
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
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
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
              const Locale.fromSubtags(languageCode: 'zh'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate
            ],
            theme: ThemeData(primarySwatch: Colors.pink),
            home: LoginScreen(),
          );
        }));
  }
}
