import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/Models/CountryCodeModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:after_init/after_init.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> with AfterInitMixin {
  List CountryList = [];

  @override
  void didInitState() {
    loadStateJson().then((jsonString) {
      setState(() {
        CountryList = json.decode(jsonString) as List;
      });

    });
  }

  @override
  Future<String> loadStateJson() async {
    return await rootBundle.loadString('assets/Countrylist.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Current Location",
            style: TextStyle(
              color: Colors.pinkAccent,
            ),
          ),
          centerTitle: true,
          textTheme:
          TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: CountryList.length != 0
            ? ListView.separated(
            padding: EdgeInsets.all(10),
            separatorBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 0.5,
                  color: Colors.black26,
                  width: MediaQuery.of(context).size.width,
                  child: Divider(),
                ),
              );
            },
            itemCount: CountryList.length,
            itemBuilder: (BuildContext context, int index) {
              Map countryinfo = CountryList[index];
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Container(
                  child: GestureDetector(
                    child: Text(countryinfo['name']),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MamaProfile(
                          cuttrenText: countryinfo['name'],
                        );
                      }));
                    },
                  ),
                ),
              );
            })
            : Container(
            child: Center(
              child: CircularProgressIndicator(),
            )));
  }
}
