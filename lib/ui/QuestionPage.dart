import 'package:after_init/after_init.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/QuestionResultModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

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
  File locProFileImage;
  List questionlist = [];
  bool isConfirm = false;
  List<QuestionResultContext> resfullist = [];

  //List questVlue = [];
  final _service = FirestoreService.instance;

  @override
  void didInitState() async {
    /*skilllist = widget.skill.split(";");
    skilllist.forEach((f) {
      getQuestions(f);
    });*/
    getQuestionsAnswersData();
  }

  _showItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        title: Container(
            color: Theme.of(context).accentColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Upload_Image',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    getImage(1);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                      ),
                      Text('Camera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImage(2);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 50,
                      ),
                      Text('Gallery'),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future getImage(int imageSelect) async {
    final dir = await path_provider.getTemporaryDirectory();
    if (imageSelect == 1) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        File imageFile = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg",
          quality: 50,
        );
        setState(() {
          locProFileImage = imageFile;
          uploadFile();
        });
      }
    } else if (imageSelect == 2) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg",
          quality: 50,
        );
        setState(() {
          locProFileImage = imageFile;
          uploadFile();
        });
      }
    }
  }

  Future uploadFile() async {
    if (locProFileImage != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(locProFileImage);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      print(storageTaskSnapshot.totalByteCount);
      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        resfullist[questionIndex].answer = downloadUrl;
      });
    }
  }

  Future<void> getQuestionsAnswersData() async {
    skilllist = widget.skill.split(";");
    questionlist = [];
    resfullist = [];
    if (skilllist != null && skilllist.length > 0) {
      for(int i=0;i<skilllist.length;i++){
        if(skilllist[i] =="Care Kids (3-12 yr old)"){
          skilllist[i] = "Care Kids";
        }
        if(skilllist[i] =="Care New-born (0-1 yr old)"){
          skilllist[i] = "New Born";
        }
        if(skilllist[i] =="Care Toddlers(1-3 yr old)"){
          skilllist[i] = "Care Toddler";
        }
      }
      int number = 0;
      do {
        String skilltext = skilllist[number];
        if (skilltext.length > 0) {
          print('skilllist data :$skilltext');
          await Firestore.instance
              .collection('mb_question_master')
              .where("skill", isEqualTo: skilltext)
              .getDocuments()
              .then((questionSnapshot) async {
            if (questionSnapshot != null &&
                questionSnapshot.documents != null &&
                questionSnapshot.documents.length > 0) {
              print('question length :${questionSnapshot.documents.length}');
              int documentsNumber = 0;
              do {
                DocumentSnapshot f =
                    questionSnapshot.documents[documentsNumber];
                questionlist.add(f);
                print('skilltext data :$skilltext');
                print('question data :${f.data}');
                print('question documentID :${f.documentID}');
                await Firestore.instance
                    .collection('mb_question_result')
                    .where("question_id", isEqualTo: f["ID"])
                    .where("profile_id", isEqualTo: widget.profileid)
                    .getDocuments()
                    .then((answerSnapshot) {
                  if (answerSnapshot != null &&
                      answerSnapshot.documents != null &&
                      answerSnapshot.documents.length > 0) {
                    resfullist.add(QuestionResultContext.fromMap(
                        answerSnapshot.documents[0].data,
                        answerSnapshot.documents[0].documentID));
                    print('answer data :${answerSnapshot.documents[0].data}}');
                    print(
                        'answer documentID :${answerSnapshot.documents[0].documentID}}');
                  } else {
                    resfullist.add(QuestionResultContext(
                      ID: null,
                      answer: null,
                      profile_id: null,
                      question_id: null,
                    ));
                  }
                });
                documentsNumber++;
              } while (documentsNumber < questionSnapshot.documents.length);
              number++;
            } else {
              number++;
            }
          });
        } else {
          number++;
        }
      } while (number < skilllist.length);
      setState(() {});
    }
  }

  Future<String> getQuestions(String skilltext) async {
    if(skilltext =="Care Kids (3-12 yr old)"){
      skilltext = "Care Kids";
    }
    if(skilltext =="Care New-born (0-1 yr old)"){
      skilltext = "New Born";
    }
    if(skilltext =="Care Toddlers(1-3 yr old)"){
      skilltext = "Care Toddler";
    }
    print(skilltext);
    Firestore.instance
        .collection('mb_question_master')
        .where("skill", isEqualTo: skilltext)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((f) async {
        questionlist.add(f);
        //questVlue.add("1");
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
                    //  questVlue[index] = value;
                  });

                  var questionresult;
                  var documentId;
                  if ((index < resfullist.length &&
                      resfullist[index].documentId != null)) {
                    documentId = resfullist[index].documentId;
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
                  _service.setData(
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
        leading: IconButton(
          color: gradientStart,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){
            if(questionIndex>-1){
              questionIndex -=1;
              setState(() {});
            }
          }
        ),
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
                    questionIndex < questionlist.length &&
                            questionIndex != -1 &&
                            questionlist[questionIndex]["step"].length>0
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            padding: EdgeInsets.all(10),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: Divider(),
                                ),
                              );
                            },
                            itemCount:
                                questionlist[questionIndex]["step"].length,
                            itemBuilder: (BuildContext context, int index) {
                              String step =
                                  questionlist[questionIndex]["step"][index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Text(
                                  step,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            },
                          )
                        : Text(""),
                    Expanded(
                      child: questionIndex != -1
                          ? (questionIndex < questionlist.length
                              ? (questionlist[questionIndex]["type"] == "mc"
                                  ? buildGrid(
                                      questionIndex,
                                      questionlist[questionIndex]["options"],
                                      questionlist[questionIndex]["ID"])
                                  : (questionlist[questionIndex]["type"] == "text"?TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                                      controller: answerController,
                                      cursorColor:
                                          Theme.of(context).accentColor,
                                      maxLines: 7,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
//                            contentPadding: new EdgeInsets.all(0.0),
//                            isDense: true,
                                          hintText: (questionIndex <
                                                      resfullist.length &&
                                                  resfullist[questionIndex]
                                                          .answer !=
                                                      null)
                                              ? resfullist[questionIndex].answer
                                              : '',
                                          hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                          border: InputBorder.none),
                                      onFieldSubmitted: (String value) {
//                                        String datenow =
//                                            DateTime.now().toIso8601String();
//                                        resfullist[questionIndex].answer =
//                                            answerController.text;
//                                        if (questionIndex <
//                                            questionlist.length) {
//                                          setState(() {
//                                            resfullist[questionIndex].answer =
//                                                value;
//                                            // questVlue[questionIndex] = value;
//                                          });
//
//                                          var questionresult;
//                                          var documentId;
//                                          if ((questionIndex <
//                                                  resfullist.length &&
//                                              resfullist[questionIndex]
//                                                      .documentId !=
//                                                  null)) {
//                                            documentId =
//                                                resfullist[questionIndex]
//                                                    .documentId;
//                                            print(
//                                                'documentID :${resfullist[questionIndex].documentId}}');
//                                            questionresult =
//                                                QuestionResultContext(
//                                              ID: resfullist[questionIndex]
//                                                  .documentId,
//                                              answer: resfullist[questionIndex]
//                                                  .answer,
//                                              profile_id: widget.profileid,
//                                              question_id:
//                                                  questionlist[questionIndex]
//                                                      ["ID"],
//                                            );
//                                          } else {
//                                            documentId = datenow;
//                                            questionresult =
//                                                QuestionResultContext(
//                                              ID: datenow,
//                                              answer: resfullist[questionIndex]
//                                                  .answer,
//                                              profile_id: widget.profileid,
//                                              question_id:
//                                                  questionlist[questionIndex]
//                                                      ["ID"],
//                                            );
//                                          }
//                                          _service.setData(
//                                              path: APIPath.newQuestionResult(
//                                                  documentId),
//                                              data: questionresult.toMap());
//                                        }
                                      },
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        resfullist[questionIndex].answer =
                                            answerController.text;
                                      },
                                    ):(resfullist[questionIndex].answer!="" && resfullist[questionIndex].answer!=null?Image.network(
                                      resfullist[questionIndex].answer,
                                      fit: BoxFit.cover,
                                    ):Text(""))
                        )
                      )
                              : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Answer completed!",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Thank you for the registration, your profile is currently under reviewed and will be posted within 2 business days.",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Good luck!",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Gud lak sa ‘yo!",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Semoga Sukses!",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Checkbox(
                                    value: isConfirm,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isConfirm = newValue;
                                      });
                                    }),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                      text: "I consent to Search4maid using my personal data to for direct marketing activities refer to",
                                      children: [
                                        TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          text: " Privacy Policy",
                                          recognizer: new TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (await canLaunch(
                                                  "https://www.search4maid.com/privacy.html")) {
                                                await launch(
                                                    "https://www.search4maid.com/privacy.html");
                                              } else {
                                                throw 'Could not launch https://www.search4maid.com/privacy.html';
                                              }
                                            },
                                        ),
                                        TextSpan(text: " &"),
                                        TextSpan(
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            text: " Terms and Conditions",
                                            recognizer: new TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (await canLaunch(
                                                    "https://www.search4maid.com/terms.html")) {
                                                  await launch(
                                                      "https://www.search4maid.com/terms.html");
                                                } else {
                                                  throw 'Could not launch https://www.search4maid.com/terms.html';
                                                }
                                              }),
                                        TextSpan(
                                            text:". It may include direct marketing from Serach4maid or our business partners."
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "Thank you for submitting your profile here. We are glad to have you in Search4maid.",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "For the next step, we may have a short quiz for you in order to full-fill the regulation requirement in Hong Kong.",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "It will take you less than 2 mins to complete the quiz",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    questionIndex!=-1 && questionIndex<questionlist.length?(questionlist[questionIndex]["type"] == "img"?Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed: () {
                              _showItemDialog();
                              setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            color: gradientStart,
                            child: Text(
                              'UpImage',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ):Text("")):Text(""),
                    questionIndex<questionlist.length && questionIndex>-1?Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed: () {
                              questionIndex -= 1;
                              setState(() {});
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            color: gradientStart,
                            child: Text(
                              'Previous',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ):Text(""),
                    questionIndex < questionlist.length
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: FlatButton(
                                  onPressed: () {
                                    if(questionIndex>-1 && questionlist[questionIndex]["type"] == "text"){
                                      String datenow =
                                            DateTime.now().toIso8601String();
                                        resfullist[questionIndex].answer =
                                            answerController.text;
                                        if (questionIndex <
                                            questionlist.length) {
                                          setState(() {
                                            resfullist[questionIndex].answer =
                                                answerController.text;
                                            // questVlue[questionIndex] = value;
                                          });

                                          var questionresult;
                                          var documentId;
                                          if ((questionIndex <
                                                  resfullist.length &&
                                              resfullist[questionIndex]
                                                      .documentId !=
                                                  null)) {
                                            documentId =
                                                resfullist[questionIndex]
                                                    .documentId;
                                            questionresult =
                                                QuestionResultContext(
                                              ID: resfullist[questionIndex]
                                                  .documentId,
                                              answer: resfullist[questionIndex]
                                                  .answer,
                                              profile_id: widget.profileid,
                                              question_id:
                                                  questionlist[questionIndex]
                                                      ["ID"],
                                            );
                                          } else {
                                            documentId = datenow;
                                            questionresult =
                                                QuestionResultContext(
                                              ID: datenow,
                                              answer: resfullist[questionIndex]
                                                  .answer,
                                              profile_id: widget.profileid,
                                              question_id:
                                                  questionlist[questionIndex]
                                                      ["ID"],
                                            );
                                          }
                                          _service.setData(
                                              path: APIPath.newQuestionResult(
                                                  documentId),
                                              data: questionresult.toMap());
                                        }
                                    }else if(questionIndex>-1 && questionlist[questionIndex]["type"] == "img"){
                                      String datenow =
                                      DateTime.now().toIso8601String();
                                      if (questionIndex <
                                          questionlist.length) {
                                        var questionresult;
                                        var documentId;
                                        if ((questionIndex <
                                            resfullist.length &&
                                            resfullist[questionIndex]
                                                .documentId !=
                                                null)) {
                                          documentId =
                                              resfullist[questionIndex]
                                                  .documentId;
                                          questionresult =
                                              QuestionResultContext(
                                                ID: resfullist[questionIndex]
                                                    .documentId,
                                                answer: resfullist[questionIndex]
                                                    .answer,
                                                profile_id: widget.profileid,
                                                question_id:
                                                questionlist[questionIndex]
                                                ["ID"],
                                              );
                                        } else {
                                          documentId = datenow;
                                          questionresult =
                                              QuestionResultContext(
                                                ID: datenow,
                                                answer: resfullist[questionIndex]
                                                    .answer,
                                                profile_id: widget.profileid,
                                                question_id:
                                                questionlist[questionIndex]
                                                ["ID"],
                                              );
                                        }
                                        _service.setData(
                                            path: APIPath.newQuestionResult(
                                                documentId),
                                            data: questionresult.toMap());
                                      }
                                    }
                                    questionIndex += 1;
                                    setState(() {});

                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: gradientStart,
                                  child: Text(
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
                    )
                        : Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: FlatButton(
                                  onPressed: () {
                                    questionIndex = -1;
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: gradientStart,
                                  child: Text(
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
