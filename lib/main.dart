import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_skill.dart';

import 'services/GetCountryListService.dart';
import 'services/database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GetCountryListService>(
          create: (_) => GetCountryListService(),
        ),
        ChangeNotifierProvider<FirestoreDatabase>(
          create: (_) => FirestoreDatabase(),
        ),
      ],
      child: MaterialApp(
        title: 'MM Helper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink
        ),
          home: LoginScreen(),
//        home:MamaProfile(),
//        home: WorkSkill(),
      ),
    );
  }
}
