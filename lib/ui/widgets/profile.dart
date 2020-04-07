import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/gender.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/first_name.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/last_name.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/whatapp.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/phone_input.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_salary.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_experiences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/Models/ProfileFirebase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';

import '../../utils/data.dart';
import '../../utils/data.dart';
import '../../utils/data.dart';
import '../../utils/data.dart';
import '../../utils/data.dart';

class MamaProfile extends StatefulWidget {
  @override
  _MamaProfileState createState() => _MamaProfileState();
  MamaProfile({this.firstName='null',this.lastName='null',this.whatappText="null",this.phoneText="null",this.workSkill="null",this.languageText="null",this.dataIndex = -1,this.dataText="null",this.workText="null",this.genderText="null",this.salaryText="null"});
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
  String salaryText;
}

class _MamaProfileState extends State<MamaProfile> with AfterInitMixin{
  final TextEditingController selfController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  static Random random = Random();
  String genderdata = "Female";
  final _service = FirestoreService.instance;
  int genderRadio = -1;
  String genderSelectedValue = "";

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
    if (widget.salaryText !="null"){
      worktexts[0] = widget.salaryText;
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
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical:10),
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
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: TextFormField(
                              scrollPadding:EdgeInsets.zero,
                              controller: firstnameController,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.all(0.0),
                                isDense: true,
                                hintText: username[0],
                                hintStyle:TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none
                              ),
                              onFieldSubmitted: (String value){
                                username[0]=firstnameController.text;
                              },
                              onEditingComplete:(){
                                FocusScope. of (context). requestFocus (FocusNode ());
                                username[0]=firstnameController.text;
                              },
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
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: TextFormField(
                              scrollPadding:EdgeInsets.zero,
                              controller: lastnameController,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.all(0.0),
                                  isDense: true,
                                  hintText: username[1],
                                  hintStyle:TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none
                              ),
                              onFieldSubmitted: (String value){
                                username[1]=lastnameController.text;
                              },
                              onEditingComplete:(){
                                FocusScope. of (context). requestFocus (FocusNode ());
                                username[1]=lastnameController.text;
                              },
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
//            Container(
//              decoration: BoxDecoration(
//                border: Border(
//                  top: BorderSide(
//                      width: 0.5,//宽度
//                      color: Colors.grey[300] //边框颜色
//                  ),
//                ),
//              ),
//              child: Padding(
//                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      flex: 11,
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            "Gender",
//                            style: TextStyle(
//                              color: Colors.grey[400],
//                              fontSize: 18,
//                            ),
//                          ),
//                          GestureDetector(
//                            child: Text(
//                              genderdata,
//                              style: TextStyle(
//                                color: Colors.black,
//                                fontSize: 18,
//                              ),
//                            ),
//                            onTap: (){
//                              Navigator.of(context)
//                                  .push(MaterialPageRoute(builder: (context) {
//                                return GenderPage();
//                              }));
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Icon(
//                        Icons.arrow_forward_ios,
//                        color: Colors.grey[400],
//                        size: 18,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal:0),
                      child: Text(
                        "Gender:",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio:4),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 0,
                                groupValue: genderRadio,
                                onChanged: genderRadioValueChange),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  genderRadioValueChange(0);
                                },
                                child: Text(
                                  "Male",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 1,
                                groupValue: genderRadio,
                                onChanged: genderRadioValueChange),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  genderRadioValueChange(1);
                                },
                                child: Text(
                                  "Female",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
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
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              datatimes,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
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
                            "Nationaity",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Select",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
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
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Detail Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
                                fontSize: 18,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                detaillinfo['text'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: TextFormField(
                              scrollPadding:EdgeInsets.zero,
                              controller: whatsappController,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.all(0.0),
                                  isDense: true,
                                  hintText: whatapptext[0],
                                  hintStyle:TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none
                              ),
                              onFieldSubmitted: (String value){
                                whatapptext[0]=whatsappController.text;
                              },
                              onEditingComplete:(){
                                FocusScope. of (context). requestFocus (FocusNode ());
                                whatapptext[0]=whatsappController.text;
                              },
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
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child:TextFormField(
                              scrollPadding:EdgeInsets.zero,
                              controller: phoneController,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.all(0.0),
                                  isDense: true,
                                  hintText: whatapptext[1],
                                  hintStyle:TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none
                              ),
                              onFieldSubmitted: (String value){
                                whatapptext[1]=phoneController.text;
                              },
                              onEditingComplete:(){
                                FocusScope. of (context). requestFocus (FocusNode ());
                                whatapptext[1]=phoneController.text;
                              },
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
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Work Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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
                                fontSize: 18,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                workinfo['text'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                            "Work Experiences",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              worktexts[2],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return WorkDate();
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
                            workend[0],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: TextFormField(
                              scrollPadding:EdgeInsets.zero,
                              controller: salaryController,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration(
                                  contentPadding: new EdgeInsets.all(0.0),
                                  isDense: true,
                                  hintText: worktexts[0],
                                  hintStyle:TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none
                              ),
                              onFieldSubmitted: (String value){
                                worktexts[0]=salaryController.text;
                              },
                              onEditingComplete:(){
                                FocusScope. of (context). requestFocus (FocusNode ());
                                worktexts[0]=salaryController.text;
                              },
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
                            workend[1],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              worktexts[1],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
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
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Self Introduction',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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

  void genderRadioValueChange(int value) {
    setState(() {
      genderRadio = value;

      switch (genderRadio) {
        case 0:
          genderSelectedValue = "Male";
          break;
        case 1:
          genderSelectedValue = "Female";
          break;
      }
    });
  }
}

