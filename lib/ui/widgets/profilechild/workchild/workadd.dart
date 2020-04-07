import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_experiences.dart';

class AddWorkDate extends StatefulWidget {
  @override
  _AddWorkDateState createState() => _AddWorkDateState();
  AddWorkDate({this.countryText="null",this.jobtypeText="null",this.takenText="null",this.reasonText="null",this.reterenceText="null"});
  String countryText;
  String jobtypeText;
  String takenText;
  String reasonText;
  String reterenceText;
}

class _AddWorkDateState extends State<AddWorkDate> with AfterInitMixin{

  @override
  void didInitState() {
    if (widget.countryText !="null"){
      addworks[0]['text']= widget.countryText;
    }
    if (widget.jobtypeText !="null"){
      addworks[3]['text']= widget.jobtypeText;
    }
    if (widget.takenText !="null"){
      addworks[4]['text']= widget.takenText;
    }
    if (widget.reasonText !="null"){
      addworks[5]['text']= widget.reasonText;
    }
    if (widget.reterenceText !="null"){
      addworks[6]['text']= widget.reterenceText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Add Work Experiences',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            child: Icon(
              Icons.check,
              color: Colors.pinkAccent,
            ),
            onPressed: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return WorkDate();
              }));
            },
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: ListView.separated(
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
          itemCount: addworks.length,
          itemBuilder: (BuildContext context, int index) {
            Map addworkinfo = addworks[index];
            return Padding(
              padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Text(
                      addworkinfo['title'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Text(
                              addworkinfo['text'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              if(index == 1 || index == 2){
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2016, 3, 5),
                                    maxTime: DateTime(2050, 6, 7), onChanged: (date) {
                                      setState(() {
                                        addworks[index]['text'] = date.toString().split(" ")[0];
                                      });
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                      setState(() {
                                        addworks[index]['text'] = date.toString().split(" ")[0];
                                      });
                                    }, currentTime: DateTime.now(), locale: LocaleType.en
                                );
                              }else{
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return addworkinfo['page'];
                                }));
                              }
                            },
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
