import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/workadd.dart';
import 'dart:math';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:after_init/after_init.dart';

class WorkDate extends StatefulWidget {
  @override
  _WorkDateState createState() => _WorkDateState();
}

class _WorkDateState extends State<WorkDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Work Experiences',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            child: Icon(
              Icons.add,
              color: Colors.pinkAccent,
            ),
            onPressed: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return AddWorkDate();
              }));
            },
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
