import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/workadd.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:after_init/after_init.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class WorkCountry extends StatefulWidget {
  @override
  _WorkCountryState createState() => _WorkCountryState();
}

class _WorkCountryState extends State<WorkCountry> with AfterInitMixin{

  List CountryLists = [];

  @override
  void didInitState() {
    loadStateJson().then((jsonString) {
      setState(() {
        CountryLists = json.decode(jsonString) as List;
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
          "Country",
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
      body:CountryLists.length != 0
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
          itemCount: CountryLists.length,
          itemBuilder: (BuildContext context, int index) {
            Map countryinfo = CountryLists[index];
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              child: Container(
                child: GestureDetector(
                  child: Text(countryinfo['name']),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddWorkDate(
                        countryText: countryinfo['name'],
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