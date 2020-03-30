import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_mmhelper/utils/data.dart';

class ChildrenPage extends StatefulWidget {
  @override
  _ChildrenPageState createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Children"),
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
          itemCount: childrens.length,
          itemBuilder: (BuildContext context, int index) {
            Map children = childrens[index];
            return Padding(
              padding:const EdgeInsets.symmetric(horizontal: 8,vertical: 15),
              child: Container(
                child: GestureDetector(
                  child: Text(
                      children['name']
                  ),
                  onTap:(){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MamaProfile(dataIndex: 3,dataText:children['name'] ,);
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
