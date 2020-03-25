import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';

class RoleUser extends StatefulWidget {
  @override
  _RoleUserState createState() => _RoleUserState();
}

class _RoleUserState extends State<RoleUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("I ma"),
        centerTitle: true,
        textTheme:
        TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("选择职业"),
            onPressed: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return SignUpScreen();
              }));
            },
          ),
        ),
      ),
    );
  }
}
