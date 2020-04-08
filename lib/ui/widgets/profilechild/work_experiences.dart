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
  WorkDate({this.workList,this.listIndex=-1});
  List workList;
  int listIndex;
}

class _WorkDateState extends State<WorkDate> with AfterInitMixin{

  @override
  void didInitState(){
    if (widget.workList.length!=0){
      if (widget.listIndex !=-1){
        workhistory[widget.listIndex]=widget.workList[0];
      }else{
        workhistory.add(widget.workList[0]);
      }
    }
  }

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
      body: Container(
        child:ListView(
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              physics:const ScrollPhysics(),
              padding: EdgeInsets.all(0),
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
              itemCount: workhistory.length,
              itemBuilder: (BuildContext context, int index) {
                Map workinfo = workhistory[index];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical:0),
                  child: Container(
                    child: ListView(
                        shrinkWrap: true,
                        physics:const ScrollPhysics(),
                        children: <Widget>[
                          Container(
                            color: Colors.grey[300],
                            width: double.infinity,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '#Work Experience ${index+1}#',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    icon:Icon(Icons.clear),
                                    onPressed: (){
                                      setState(() {
                                        workhistory.removeAt(index);
                                      });
                                    },
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Country",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo["country"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Start Date",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo["start"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "End Date",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo['end'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Type of Jobs",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo['jobtype'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Number of Taken Care",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo['taken'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Quit Reason",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo['reason'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Reterence Letter",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      workinfo['reterence'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                );
              }
            ),
            workhistory.length!=0?Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed:(){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MamaProfile(workHistory: "${workhistory.length} work experiences",);
                      }));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color:Colors.pinkAccent,
                    child:Text(
                      'push',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ):null,
          ]
        ),
      ),
    );
  }
}
