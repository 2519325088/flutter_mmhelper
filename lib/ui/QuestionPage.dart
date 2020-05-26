import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  final TextEditingController answerController = TextEditingController();
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  List skilllist = [];
  int questionIndex = -1;
  List questionlist = [];
  List<QuestionResultContext> resfullist = [];
  List questVlue = [];
  final _service = FirestoreService.instance;

  @override
  void didInitState() {
    skilllist = widget.skill.split(";");
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
        // setState(() {});
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
          } else {
            resfullist.add(QuestionResultContext(
              ID: null,
              answer: null,
              profile_id: null,
              question_id: null,
            ));
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
    print(resfullist[index].answer);
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
                print('value:$value');
                print('questionIndex:$questionIndex');
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
                          data: questionresult.toMap());
                }
              },
            ),
          ),
        ));

    content = new Column(
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
      ),
      body: Container(
        child: questionlist.length != 0
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      questionIndex < questionlist.length && questionIndex != -1
                          ? "${questionIndex + 1}. ${questionlist[questionIndex]["question"]}"
                          : "",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    questionIndex < questionlist.length && questionIndex != -1 && questionlist[questionIndex]["step"][0]!=""?ListView.separated(
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
                      itemCount: questionlist[questionIndex]["step"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String step = questionlist[questionIndex]["step"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                          child: Text(step,
                            style: TextStyle(
                              fontSize: 18,
                            ),),
                        );
                      },
                    ):Text(""),
                    Expanded(
                      child: questionIndex !=-1 ?(questionIndex < questionlist.length
                          ? (questionlist[questionIndex]["type"]=="mc"?buildGrid(
                              questionIndex,
                              questionlist[questionIndex]["options"],
                              questionlist[questionIndex]["ID"]):TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                        controller: answerController,
                        cursorColor: Theme.of(context).accentColor,
                        maxLines: 5,
                        maxLength: 50,
                        textInputAction:TextInputAction.done,
                        decoration: InputDecoration(
//                            contentPadding: new EdgeInsets.all(0.0),
//                            isDense: true,
                            hintText: (questionIndex< resfullist.length &&
                        resfullist[questionIndex].answer != null)
                            ? resfullist[questionIndex].answer
                            : '',
                            hintStyle:TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value) {
                          print(questionIndex);
                          String datenow = DateTime.now().toIso8601String();
                          resfullist[questionIndex].answer =
                              answerController.text;
                          if (questionIndex < questionlist.length) {
                            setState(() {
                              resfullist[questionIndex].answer = value;
                              questVlue[questionIndex] = value;
                            });

                            var questionresult;
                            var documentId;
                            if ((questionIndex < resfullist.length &&
                                resfullist[questionIndex].documentId != null)) {
                              documentId = resfullist[questionIndex].documentId;
                              print('documentID :${resfullist[questionIndex]
                                  .documentId}}');
                              questionresult = QuestionResultContext(
                                ID: resfullist[questionIndex].documentId,
                                answer: resfullist[questionIndex].answer,
                                profile_id: widget.profileid,
                                question_id: questionlist[questionIndex]["ID"],
                              );
                            } else {
                              documentId = datenow;
                              questionresult = QuestionResultContext(
                                ID: datenow,
                                answer: resfullist[questionIndex].answer,
                                profile_id: widget.profileid,
                                question_id: questionlist[questionIndex]["ID"],
                              );
                            }
                            _service
                                .setData(
                                path: APIPath.newQuestionResult(documentId),
                                data: questionresult.toMap());
                            }
                          },
                          onEditingComplete:
                              () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            resfullist[questionIndex].answer =
                                answerController.text;
                          },
                      ))
                      : Center(
                          child: Text(
                              "Answer completed!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                          ))): Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Thank you for submitting your profile here. We are glad to have you in Search4maid.",
                            style: TextStyle(
                              fontSize: 18,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("For the next step, we may have a short quiz for you in order to full-fill the regulation requirement in Hong Kong.",
                              style: TextStyle(
                                fontSize: 18,
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("It will take you less than 2 mins to complete the quiz",
                              style: TextStyle(
                                fontSize: 18,
                              ),),
                          ),
                        ],
                      ),
                    ),
                    questionIndex < questionlist.length?Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed:(){
                              questionIndex += 1;
                              setState(() {});
                              print(questionIndex);
                              print(questionlist);
                              print(resfullist);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            color:gradientStart,
                            child:Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ):Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed:(){
                              questionIndex = - 1;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            color:gradientStart,
                            child:Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
