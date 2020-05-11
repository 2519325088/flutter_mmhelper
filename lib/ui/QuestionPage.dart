import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_init/after_init.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
  String profileid;
  String skill;
  QuestionPage({this.profileid,this.skill});
}

class _QuestionPageState extends State<QuestionPage> with AfterInitMixin{

  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  List skilllist = [];
  List questionlist = [];
  List resfullist = [];
  @override
  void didInitState() {
    print(widget.profileid);
    skilllist = widget.skill.split(";");
    print(skilllist);
    skilllist.forEach((f){
      getQuestions(f);
    });
  }

  Future<String> getQuestions (String skilltext) async{
    Firestore.instance
        .collection('mb_question_master')
        .where("skill", isEqualTo: skilltext)
        .getDocuments()
        .then((snapshot){
      snapshot.documents.forEach((f){
        questionlist.add(f);
        Firestore.instance
            .collection('mb_question_result')
            .where("question_id", isEqualTo: f["ID"])
            .where("profile_id", isEqualTo: widget.profileid)
            .getDocuments()
            .then((snapshot){
          snapshot.documents.forEach((f){
            resfullist.add(f);
            print(resfullist.length);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:gradientStart,
        title:Text(
          "Question",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(

        ),
      ),
    );
  }
}
