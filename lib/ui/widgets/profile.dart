import 'dart:math';
import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/gender.dart';

class MamaProfile extends StatefulWidget {
  @override
  _MamaProfileState createState() => _MamaProfileState();
  MamaProfile({this.dataIndex = -1,this.dataText="null",this.workText="null",this.genderText="null"});
  int dataIndex;
  String dataText;
  String workText;
  String genderText;
}

class _MamaProfileState extends State<MamaProfile> with AfterInitMixin{
  static Random random = Random();
  String genderdata = "Female";

  @override
  void didInitState() {
    if (widget.dataIndex != -1 && widget.dataText !="null"){
      detaills[widget.dataIndex]["text"]=widget.dataText;
    }
    if (widget.dataIndex != -1 && widget.workText !="null"){
      works[widget.dataIndex]["text"]=widget.workText;
    }
    if (widget.genderText !="null"){
      genderdata = widget.genderText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Profile',
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
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Text(
                  'Basic Intormation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "First Name",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "Mama",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Last Name",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "Helpers",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              genderdata,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return GenderPage();
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Birthday",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "Select",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "NationAity",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "Select",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Text(
                  'Detaill Intormation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics:const ScrollPhysics(),
              padding: EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Divider(),
                  ),
                );
              },
              itemCount: detaills.length,
              itemBuilder: (BuildContext context, int index) {
                Map detaillinfo = detaills[index];
                return Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              detaillinfo['title'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 22,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                detaillinfo['text'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return detaillinfo['page'];
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "WhatsApp",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "+85263433995",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Phone Number (verified)",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "+85263433995",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child:Text(
                        "Private",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                      ),
//                      child: Icon(
//                        Icons.arrow_forward_ios,
//                        color: Colors.grey[400],
//                        size: 18,
//                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Text(
                  'Work Intormation',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics:const ScrollPhysics(),
              padding: EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Divider(),
                  ),
                );
              },
              itemCount: works.length,
              itemBuilder: (BuildContext context, int index) {
                Map workinfo = works[index];
                return Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              workinfo['title'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 22,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                workinfo['text'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return workinfo['page'];
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

