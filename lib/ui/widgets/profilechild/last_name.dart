import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';

class LastName extends StatefulWidget {
  @override
  _LastNameState createState() => _LastNameState();
}

class _LastNameState extends State<LastName> {
  final TextEditingController firstnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Last Name',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 0.5,//宽度
                color: Colors.black //边框颜色
            ),
          ),
          child: TextFormField(
            controller: firstnameController,
            cursorColor: Theme.of(context).accentColor,
            decoration: InputDecoration(
//                prefixIcon: Icon(Icons.account_circle),
//                hintText: "Role",
                border: InputBorder.none),
            onFieldSubmitted: (String value){
//              Navigator.of(context)
//                  .push(MaterialPageRoute(builder: (context) {
//                return MamaProfile(lastName: value,);
//              }));
            },
          ),
        ),
      ),
    );
  }
}
