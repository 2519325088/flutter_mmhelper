import 'dart:math';
import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/gender.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/first_name.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/last_name.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/whatapp.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/phone_input.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/Models/ProfileFirebase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';

class MamaProfile extends StatefulWidget {
  @override
  _MamaProfileState createState() => _MamaProfileState();
  MamaProfile({this.firstName='null',this.lastName='null',this.whatappText="null",this.phoneText="null",this.workSkill="null",this.languageText="null",this.dataIndex = -1,this.dataText="null",this.workText="null",this.genderText="null"});
  int dataIndex;
  String firstName;
  String lastName;
  String dataText;
  String workText;
  String genderText;
  String workSkill;
  String languageText;
  String whatappText;
  String phoneText;
}

class _MamaProfileState extends State<MamaProfile> with AfterInitMixin{
  final TextEditingController selfController = TextEditingController();
  static Random random = Random();
  String genderdata = "Female";
  final _service = FirestoreService.instance;

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
    if (widget.firstName !="null"){
      username[0] = widget.firstName;
    }
    if (widget.lastName !="null"){
      username[1] = widget.lastName;
    }
    if (widget.whatappText !="null"){
      whatapptext[0] = widget.whatappText;
    }
    if (widget.phoneText !="null"){
      whatapptext[1] = widget.phoneText;
    }
    if (widget.dataIndex != -1 && widget.workSkill !="null"){
      works[widget.dataIndex]["text"]=widget.workSkill;
    }
    if (widget.dataIndex != -1 && widget.workSkill ==""){
      works[widget.dataIndex]["text"]="Select";
    }

    if (widget.dataIndex != -1 && widget.languageText !="null"){
      works[widget.dataIndex]["text"]=widget.languageText;
    }
    if (widget.dataIndex != -1 && widget.languageText ==""){
      works[widget.dataIndex]["text"]="Select";
    }
  }

  Future<void> _submit() async {
    final database = Provider.of<FirestoreDatabase>(context);
//    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = reference.putFile(locProFileImage);
//    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//    print(storageTaskSnapshot.totalByteCount);
//    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
    final procontext = ProContext(
      firstname: username[0],
      lastname: username[1],
      gender: genderdata,
      birthday: datatimes,
      nationaity: "",
      education: detaills[0]['text'],
      religion: detaills[1]['text'],
      marital: detaills[2]['text'],
      children: detaills[3]['text'],
      current: detaills[4]['text'],
      whatsapp: whatapptext[0],
      phone: whatapptext[1],
      jobtype: works[0]['text'],
      jobcapacity: works[1]['text'],
      contract: works[2]['text'],
      workskill: works[3]['text'],
      language: works[4]['text'],
    );
    _service.setData(path: APIPath.newCandidate(database.lastUserId),
        data: procontext.toMap());
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
                          GestureDetector(
                            child: Text(
                              username[0],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                                return FirstName();
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
                            "Last Name",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 22,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              username[1],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return LastName();
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
                          GestureDetector(
                            child: Text(
                              datatimes,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2016, 3, 5),
                                  maxTime: DateTime(2050, 6, 7), onChanged: (date) {
                                    setState(() {
                                      datatimes = date.toString().split(" ")[0];
                                    });
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    setState(() {
                                      datatimes = date.toString().split(" ")[0];
                                    });
                                  }, currentTime: DateTime.now(), locale: LocaleType.en
                              );
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
                          GestureDetector(
                            child: Text(
                              whatapptext[0],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return WhatAppPage();
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
                          GestureDetector(
                            child: Text(
                              whatapptext[1],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PhonePage();
                              }));
                            },
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
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Text(
                  'Self Intormation',
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
                child: TextField(
                  controller: selfController,
                  maxLength: 500,
                  maxLines: 10,
                  autofocus: false,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed:_submit,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color:Colors.pinkAccent,
                    child:Text(
                      'logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

