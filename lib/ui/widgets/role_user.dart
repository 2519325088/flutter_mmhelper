import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';
import 'package:flutter_mmhelper/utils/data.dart';

class RoleUser extends StatefulWidget {
  @override
  _RoleUserState createState() => _RoleUserState();
  final ValueChanged<String> onChanged;///this is type is valueChange<here you can any type like int,string,bool>
  RoleUser({this.onChanged});///this is same but vauechange function we can use on previous page
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
        itemCount: roleds.length,
        itemBuilder: (BuildContext context, int index) {
          Map roled = roleds[index];
          return Padding(
            padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
            child: Container(
              child: GestureDetector(
                child: Text(
                  roled['name']
                ),
                onTap:(){
               /* Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return SignUpScreen(dataFromOtherScreen:roled['name']);
                }));*/
               widget.onChanged(roled['name']);
               Navigator.pop(context);///here i just pop to back screen
              } ,
              ),
            ),
          );
        }
      ),
    );
  }
}
