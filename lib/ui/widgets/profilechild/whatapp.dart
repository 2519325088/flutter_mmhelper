import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';

class WhatAppPage extends StatefulWidget {
  @override
  _WhatAppPageState createState() => _WhatAppPageState();
}

class _WhatAppPageState extends State<WhatAppPage> {
  final TextEditingController whatappController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'WhatApp',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey[800],
        ),
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
            controller: whatappController,
            cursorColor: Theme.of(context).accentColor,
            decoration: InputDecoration(
//                prefixIcon: Icon(Icons.account_circle),
//                hintText: "Role",
                border: InputBorder.none),
            onFieldSubmitted: (String value){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return MamaProfile(whatappText: value,);
              }));
            },
//            onSaved: (String value){
//              Navigator.of(context)
//                  .push(MaterialPageRoute(builder: (context) {
//                return MamaProfile(firstName: value,);
//              }));
//            },
          ),
        ),
      ),
    );
  }
}
