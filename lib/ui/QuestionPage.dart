import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/QuestionResultModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
  String profileid;
  String skill;
  QuestionPage({this.profileid, this.skill});
}

class _QuestionPageState extends State<QuestionPage> with AfterInitMixin {
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  List skilllist = [];
  int questionIndex = 0;
  List questionlist = [];
  List<QuestionResultContext> resfullist = [];
  List questVlue = [];
  final _service = FirestoreService.instance;

  @override
  void didInitState() {
    print(widget.profileid);
    skilllist = widget.skill.split(";");
    print(skilllist);
    skilllist.forEach((f) {
      getQuestions(f);
    });
  }

  Future<String> getQuestions(String skilltext) async {
    Firestore.instance
        .collection('mb_question_master')
        .where("skill", isEqualTo: skilltext)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((f) async {
        questionlist.add(f);
        questVlue.add("1");
        setState(() {});
        Firestore.instance
            .collection('mb_question_result')
            .where("question_id", isEqualTo: f["ID"])
            .where("profile_id", isEqualTo: widget.profileid)
            .getDocuments()
            .then((snapshot) {
          if (snapshot != null &&
              snapshot.documents != null &&
              snapshot.documents.length > 0) {
            resfullist.add(QuestionResultContext.fromMap(
                snapshot.documents[0].data, snapshot.documents[0].documentID));
            print('data :${snapshot.documents[0].data}}');
            print('documentID :${snapshot.documents[0].documentID}}');
            setState(() {});
          }
          /*  snapshot.documents.forEach((f) async {
            resfullist.add(f);
            print('snapshot :${f.data}}');
            setState(() {});
          });*/
        });
      });
    });
  }

  Widget buildGrid(int index, Map options, String questionid) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    options.forEach((k, v) => tiles.add(
          new Flexible(
            child: RadioListTile<String>(
              value: v,
              title: Text(v),
              groupValue: (index < resfullist.length &&
                      resfullist[index].answer != null)
                  ? resfullist[index].answer
                  : '',
              onChanged: (value) {
                String datenow = DateTime.now().toIso8601String();
                print(1111);
                print(questionIndex);
//            Firestore.instance
//                .collection('mb_question_result')
//                .where("question_id", isEqualTo:questionid)
//                .where("profile_id", isEqualTo: widget.profileid)
//                .getDocuments()
//                .then((snapshot){
//                  print(snapshot.documents.length);
//                  if(snapshot.documents.length > 0){
//                    value = snapshot.documents[0]["answer"];
//                    setState(() {
//                      questVlue[index] = value;
//                    });
//                  }
////                  snapshot.documents.forEach((f) async{
////                    if (resfullist.length !=0)
////                    value = f["answer"];
////                    print(resfullist.length);
////                  });
//            });
                if (questionIndex < questionlist.length) {
                  setState(() {
                    resfullist[index].answer = value;
                    questVlue[index] = value;
                  });
                  
                  var questionresult;
                  var documentId;
                  if ((index < resfullist.length &&
                      resfullist[index].documentId != null)) {
                    documentId = resfullist[index].documentId;
                    print('documentID :${resfullist[index].documentId}}');
                    questionresult = QuestionResultContext(
                      ID: resfullist[index].documentId,
                      answer: resfullist[index].answer,
                      profile_id: widget.profileid,
                      question_id: questionid,
                    );
                  } else {
                    documentId = datenow;
                    questionresult = QuestionResultContext(
                      ID: datenow,
                      answer: resfullist[index].answer,
                      profile_id: widget.profileid,
                      question_id: questionid,
                    );
                  }
                  _service
                      .setData(
                          path: APIPath.newQuestionResult(documentId),
                          data: questionresult.toMap())
                      .then((value) {
                    questionIndex += 1;
                    setState(() {});
                    print(2222);
                    print(questionlist.length);
                  });
                }
              },
            ),
          ),
        ));

    content = new Row(
        children: tiles //重点在这里，因为用编辑器写Column生成的children后面会跟一个<Widget>[]，
        //此时如果我们直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
        );
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
          "Question",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            color: gradientStart,
            icon: Icon(
              Icons.check,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
//        child: questionlist.length!=0?ListView.separated(
//          shrinkWrap: true,
//          physics:const ScrollPhysics(),
//          padding: EdgeInsets.all(10),
//          separatorBuilder: (BuildContext context, int index) {
//            return Align(
//              alignment: Alignment.centerRight,
//              child: Container(
//                height: 0.5,
//                width: MediaQuery.of(context).size.width,
//                child: Divider(),
//              ),
//            );
//          },
//          itemCount: questionlist.length,
//          itemBuilder: (BuildContext context, int index) {
//            DocumentSnapshot question = questionlist[index];
//            return Padding(
//              padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "${index+1}. ${question["question"]}",
//                    style: TextStyle(
//                      fontSize: 20,
//                    ),
//                  ),
//                  buildGrid(index,question["options"]),
//                ],
//              )
//            );
//          },
//        ):Center(
//          child: CircularProgressIndicator(),
//        ),
        child: questionlist.length != 0
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      questionIndex < questionlist.length
                          ? "${questionIndex + 1}. ${questionlist[questionIndex]["question"]}"
                          : "",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    questionIndex < questionlist.length
                        ? buildGrid(
                            questionIndex,
                            questionlist[questionIndex]["options"],
                            questionlist[questionIndex]["ID"])
                        : Text(""),
                  ],
                ))
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
