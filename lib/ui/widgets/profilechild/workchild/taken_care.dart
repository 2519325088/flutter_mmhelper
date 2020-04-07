import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/workadd.dart';
import 'package:flutter_mmhelper/utils/data.dart';

class TakenCare extends StatefulWidget {
  @override
  _TakenCareState createState() => _TakenCareState();
}

class _TakenCareState extends State<TakenCare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Number of Taken Care",
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
      body: ListView.separated(
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
          itemCount: takencares.length,
          itemBuilder: (BuildContext context, int index) {
            Map takencare = takencares[index];
            return Padding(
              padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
              child: Container(
                child: GestureDetector(
                  child: Text(
                      takencare['name']
                  ),
                  onTap:(){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddWorkDate(takenText: takencare['name'],);
                    }));
                  } ,
                ),
              ),
            );
          }
      ),
    );
  }
}
