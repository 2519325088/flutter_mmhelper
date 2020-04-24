import 'dart:convert';

import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/AddWorkExperiencePage.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyJobProfilePage extends StatefulWidget {
  @override
  _MyJobProfilePageState createState() => _MyJobProfilePageState();
  final String userId;

  MyJobProfilePage({this.userId});
}

class _MyJobProfilePageState extends State<MyJobProfilePage>
    with AfterInitMixin {
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstNameCtr = TextEditingController();
  TextEditingController lastNameCtr = TextEditingController();
  TextEditingController genderCtr = TextEditingController();
  TextEditingController birthDayCtr = TextEditingController();
  TextEditingController nationalityCtr = TextEditingController();
  TextEditingController eduCtr = TextEditingController();
  TextEditingController religionCtr = TextEditingController();
  TextEditingController maritalCtr = TextEditingController();
  TextEditingController childCtr = TextEditingController();
  TextEditingController locationCtr = TextEditingController();
  TextEditingController whatsAppCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController jobTypeCtr = TextEditingController();
  TextEditingController jobCapCtr = TextEditingController();
  TextEditingController contractCtr = TextEditingController();
  TextEditingController workingSkillCtr = TextEditingController();
  TextEditingController languageCtr = TextEditingController();
  TextEditingController expectedSalaryCtr = TextEditingController();
  TextEditingController startDateCtr = TextEditingController();
  TextEditingController selfCtr = TextEditingController();
  DateTime startDate;
  DateTime birthDayDate;
  ProfileData profileData = ProfileData();
  List<Widget> eduWidget = [];
  List<Widget> religionWidget = [];
  List<Widget> maritalStatusWidget = [];
  List<Widget> childrenWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> jobCapWidget = [];
  List<Widget> contractWidget = [];
  List<Widget> workingSkillWidget = [];
  List<Widget> languageWidget = [];
  List<String> workingSkillStringList = [];
  List<String> languageChips = [];
  List<Asset> imagesa = List<Asset>();
  String _error = 'No Error Dectected';
  final _service = FirestoreService.instance;
  QuerySnapshot profileQuerySnapshot;
  ScrollController scrollController = ScrollController();
  bool isEdit = false;
  int exIndex;

  Future<QuerySnapshot> getMyJobProfile() async {
    return await Firestore.instance
        .collection("mb_profile")
        .where("id", isEqualTo: widget.userId)
        .getDocuments();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileData.imagelist = [];
    profileData.workexperiences = [];
    getMyJobProfile().then((onValue) {
      if (onValue.documents.length != 0) {
        firstNameCtr.text = onValue.documents[0]["firstname"];
        profileData.firstname = onValue.documents[0]["firstname"];
        lastNameCtr.text = onValue.documents[0]["lastname"];
        profileData.lastname = onValue.documents[0]["lastname"];
        genderCtr.text = onValue.documents[0]["gender"];
        profileData.gender = onValue.documents[0]["gender"];
        birthDayCtr.text = DateFormat.yMMMMEEEEd()
            .format(DateTime.parse(onValue.documents[0]["birthday"]));
        profileData.birthday = DateTime.parse(onValue.documents[0]["birthday"]);
        nationalityCtr.text = onValue.documents[0]["nationaity"];
        profileData.nationaity = onValue.documents[0]["nationaity"];
        eduCtr.text = onValue.documents[0]["education"];
        profileData.education = onValue.documents[0]["education"];
        religionCtr.text = onValue.documents[0]["religion"];
        profileData.religion = onValue.documents[0]["religion"];
        maritalCtr.text = onValue.documents[0]["marital"];
        profileData.marital = onValue.documents[0]["marital"];
        childCtr.text = onValue.documents[0]["children"];
        profileData.children = onValue.documents[0]["children"];
        locationCtr.text = onValue.documents[0]["current"];
        profileData.current = onValue.documents[0]["current"];
        whatsAppCtr.text = onValue.documents[0]["whatsapp"];
        profileData.whatsapp = onValue.documents[0]["whatsapp"];
        phoneCtr.text = onValue.documents[0]["phone"];
        profileData.phone = onValue.documents[0]["phone"];
        jobTypeCtr.text = onValue.documents[0]["jobtype"];
        profileData.jobtype = onValue.documents[0]["jobtype"];
        jobCapCtr.text = onValue.documents[0]["jobcapacity"];
        profileData.jobcapacity = onValue.documents[0]["jobcapacity"];
        contractCtr.text = onValue.documents[0]["contract"];
        profileData.contract = onValue.documents[0]["contract"];
        expectedSalaryCtr.text = onValue.documents[0]["expectedsalary"];
        profileData.expectedsalary = onValue.documents[0]["expectedsalary"];
        startDateCtr.text = DateFormat.yMMMMEEEEd()
            .format(DateTime.parse(onValue.documents[0]["employment"]));
        profileData.employment =
            DateTime.parse(onValue.documents[0]["employment"]);
        selfCtr.text = onValue.documents[0]["selfintroduction"];
        profileData.selfintroduction = onValue.documents[0]["selfintroduction"];
        texttags.forEach((f) {
          workingSkillWidget.add(WorkChips(
            title: f,
            workingSkillStringList: workingSkillStringList,
            isSelected:
            onValue.documents[0]["workskill"].toString().contains(f),
          ));
          workingSkillWidget.add(SizedBox(
            width: 5,
          ));
        });
        language.forEach((f) {
          languageWidget.add(LanguageChips(
            title: f,
            languageStringList: languageChips,
            isSelected: onValue.documents[0]["language"].toString().contains(f),
          ));
          languageWidget.add(SizedBox(
            width: 5,
          ));
        });
        setState(() {});
        onValue.documents[0]["workexperiences"].forEach((f) {
          profileData.workexperiences.add(Workexperience.fromMap(
              (f)));
        });
        onValue.documents[0]["imagelist"].forEach((f) {
          profileData.imagelist.add(f);
        });
      } else {
        texttags.forEach((f) {
          workingSkillWidget.add(WorkChips(
            title: f,
            workingSkillStringList: workingSkillStringList,
            isSelected: false,
          ));
          workingSkillWidget.add(SizedBox(
            width: 5,
          ));
        });
        language.forEach((f) {
          languageWidget.add(LanguageChips(
            title: f,
            languageStringList: languageChips,
            isSelected: false,
          ));
          languageWidget.add(SizedBox(
            width: 5,
          ));
        });
        setState(() {});
      }
    });

    education.forEach((f) {
      eduWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            eduCtr.text = f;
            profileData.education = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    religion.forEach((f) {
      religionWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            religionCtr.text = f;
            profileData.religion = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    marital.forEach((f) {
      maritalStatusWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            maritalCtr.text = f;
            profileData.marital = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    children.forEach((f) {
      childrenWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            childCtr.text = f;
            profileData.children = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    jobtype.forEach((f) {
      jobTypeWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            jobTypeCtr.text = f;
            profileData.jobtype = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    jobcapacity.forEach((f) {
      jobCapWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            jobCapCtr.text = f;
            profileData.jobcapacity = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    contract.forEach((f) {
      contractWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            contractCtr.text = f;
            profileData.contract = f;
            Navigator.pop(context);
          },
        ),
      );
    });
  }

  onWorkingExChange(Workexperience workExperience) {
    if (isEdit == false) {
      profileData.workexperiences.add(workExperience);
    } else {
      profileData.workexperiences.removeAt(exIndex);
      profileData.workexperiences.add(workExperience);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameCtr.dispose();
    lastNameCtr.dispose();
    genderCtr.dispose();
    birthDayCtr.dispose();
    nationalityCtr.dispose();
    eduCtr.dispose();
    religionCtr.dispose();
    maritalCtr.dispose();
    childCtr.dispose();
    locationCtr.dispose();
    whatsAppCtr.dispose();
    phoneCtr.dispose();
    jobTypeCtr.dispose();
    jobCapCtr.dispose();
    contractCtr.dispose();
    workingSkillCtr.dispose();
    languageCtr.dispose();
    expectedSalaryCtr.dispose();
    startDateCtr.dispose();
    selfCtr.dispose();
    scrollController.dispose();
  }

  //  sumbit image
  Future<String> saveImage(Asset asset) async {
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.totalByteCount);
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cardTitleText = TextStyle(fontSize: 20, color: Colors.black);
    TextStyle titleText =
    TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7));
    TextStyle dataText = TextStyle(fontSize: 20);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("My Job Profile"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (isLoading == false) {
                  setState(() {
                    isLoading = true;
                  });
                  String workingSkillString = "";
                  String languageString = "";
                  workingSkillStringList.forEach((f) {
                    workingSkillString += "$f;";
                  });
                  languageChips.forEach((f) {
                    languageString += "$f;";
                  });
                  profileData.workskill = workingSkillString;
                  profileData.language = languageString;
                  profileData.id = DateTime.parse(widget.userId);
                  int i = 1;
                  if (imagesa.length != 0) {
                    imagesa.forEach((upFile) async {
                      String downloadLink = await saveImage(upFile);
                      profileData.imagelist.add(downloadLink);
                      i += 1;
                      if (i > imagesa.length) {
                        print("Profile update call");
                        _service
                            .setData(
                            path: APIPath.newProfile(widget.userId),
                            data: profileData.toMap())
                            .then((onValue) {
                          setState(() {
                            isLoading = false;
                            imagesa.clear();
                          });
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Profile Update Succussfully.")));
                        });
                      }
                    });
                  } else {
                    if (profileData.imagelist.length != 0) {
                      _service
                          .setData(
                          path: APIPath.newProfile(widget.userId),
                          data: profileData.toMap())
                          .then((onValue) {
                        setState(() {
                          isLoading = false;
                          imagesa.clear();
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Profile Update Succussfully.")));
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Please select Image")));
                    }
                  }
                } else {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Wait data is updating...")));
                }
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Basic Information",
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "First Name:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.firstname = newValue;
                                            },
                                            controller: firstNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Enter first name"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Last Name:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.lastname = newValue;
                                            },
                                            controller: lastNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Enter last name"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Gender:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: genderCtr,
                                            decoration: InputDecoration(
                                                hintText: "Select Gender"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Gender",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    child: Text("Male"),
                                                    onPressed: () {
                                                      genderCtr.text = "Male";
                                                      profileData.gender =
                                                      "Male";
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text("Female"),
                                                    onPressed: () {
                                                      genderCtr.text = "Female";
                                                      profileData.gender =
                                                      "Female";
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Birthday:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              selectBirthDayDate(context);
                                            },
                                            controller: birthDayCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Select Birthday"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Nationality:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.nationaity = newText;
                                            },
                                            controller: nationalityCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Enter nationality"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Detail Information",
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Education:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: eduCtr,
                                            decoration: InputDecoration(
                                                hintText: "Select Education"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Education",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: eduWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Religion:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: religionCtr,
                                            decoration: InputDecoration(
                                                hintText: "Select Religion"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Religion",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: religionWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Marital Status:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: maritalCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Select Marital Status"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Marital Status",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: maritalStatusWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Children:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: childCtr,
                                            decoration: InputDecoration(
                                                hintText: "Select Children"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Children",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: childrenWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Current Location:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.current = newText;
                                            },
                                            controller: locationCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Enter current location"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Whatsapp Number:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.whatsapp = "$newText";
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  15),
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              BlacklistingTextInputFormatter
                                                  .singleLineFormatter,
                                            ],
                                            keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false,
                                                decimal: false),
                                            controller: whatsAppCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Enter whatsapp number"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Phone Number (verified):",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.phone = "$newText";
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  15),
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              BlacklistingTextInputFormatter
                                                  .singleLineFormatter,
                                            ],
                                            keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false,
                                                decimal: false),
                                            controller: phoneCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Enter Phone number"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Work Information",
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Job Type:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobTypeCtr,
                                            decoration: InputDecoration(
                                                hintText: "Select Job Type"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Job Type",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobTypeWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Job Capacity:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobCapCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Select Job Capacity"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Job Capacity",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobCapWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Contract Status:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: contractCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Select Contract Status"),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                              CupertinoActionSheet(
                                                title: Text(
                                                  "Contract Status",
                                                  style:
                                                  TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  "Select any option ",
                                                  style:
                                                  TextStyle(fontSize: 15.0),
                                                ),
                                                actions: contractWidget,
                                                cancelButton:
                                                CupertinoActionSheetAction(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder: (context) => action);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Working Skill:",
                                            style: titleText,
                                          ),
                                          Wrap(children: workingSkillWidget)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Language:",
                                            style: titleText,
                                          ),
                                          Wrap(children: languageWidget)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Expected Salary(HKD):",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.expectedsalary =
                                                  newValue;
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  15),
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              BlacklistingTextInputFormatter
                                                  .singleLineFormatter,
                                            ],
                                            keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false,
                                                decimal: false),
                                            controller: expectedSalaryCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                "Enter expected salary"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Employement Start Date:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              selectStartDate(context);
                                            },
                                            controller: startDateCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: "Select Date"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Work Experience",
                                      style: cardTitleText,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          isEdit = false;
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return AddWorkExperiencePage(
                                                      onChanged: onWorkingExChange,
                                                    );
                                                  }));
                                        },
                                        child: Icon(Icons.add)),
                                  ],
                                ),
                              )),
                          profileData.workexperiences.length != 0
                              ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: profileData.workexperiences.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    isEdit = true;
                                    exIndex = index;
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return AddWorkExperiencePage(
                                                onChanged: onWorkingExChange,
                                                oldWorkExperience: profileData
                                                    .workexperiences[index],
                                              );
                                            }));
                                  },
                                  title: Text(
                                    profileData
                                        .workexperiences[index].jobtype,
                                    style: titleText,
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () {
                                        setState(() {
                                          profileData.workexperiences
                                              .removeAt(index);
                                        });
                                      }),
                                );
                              })
                              : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8),
                            child: Text(
                              "Add your work experince",
                              style: titleText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Self Introduction",
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  onChanged: (newValue) {
                                    profileData.selfintroduction = newValue;
                                  },
                                  maxLines: 5,
                                  controller: selfCtr,
                                  style: dataText,
                                  decoration: InputDecoration(
                                      hintText: "Enter self introduction"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Image Introduction",
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      profileData.imagelist.length != 0
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Server Image",
                                              style: titleText,
                                            ),
                                          ),
                                          profileData.imagelist.length !=
                                              0
                                              ? editBuildGridView()
                                              : SizedBox(),
                                        ],
                                      )
                                          : SizedBox(),
                                      imagesa.length != 0
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Local Image",
                                              style: titleText,
                                            ),
                                          ),
                                          imagesa.length != 0
                                              ? buildGridView()
                                              : Text(""),
                                        ],
                                      )
                                          : SizedBox(),
                                      RaisedButton(
                                        child: Text("Pick images"),
                                        onPressed: loadAssets,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: isLoading
                  ? Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : SizedBox())
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(imagesa.length, (index) {
        Asset asset = imagesa[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Widget editBuildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(profileData.imagelist.length, (index) {
        return Stack(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: profileData.imagelist[index],
              height: 300,
              width: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      profileData.imagelist.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.black45,
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imagesa,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imagesa = resultList;
      _error = error;
    });
  }

  Future<void> selectBirthDayDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 21900)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDayDate = picked;
        birthDayCtr.text = DateFormat.yMMMMEEEEd().format(birthDayDate);
        profileData.birthday = birthDayDate;
      });
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        startDateCtr.text = DateFormat.yMMMMEEEEd().format(startDate);
        profileData.employment = startDate;
      });
    }
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();
  }
}

class WorkChips extends StatefulWidget {
  @override
  _WorkChipsState createState() => _WorkChipsState();
  final String title;
  List<String> workingSkillStringList;
  bool isSelected;

  WorkChips({this.title, this.workingSkillStringList, this.isSelected});
}

class _WorkChipsState extends State<WorkChips> {
  bool isSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.isSelected;
    if (isSelected) {
      widget.workingSkillStringList.add(widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(widget.title),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          isSelected = selected;
          if (isSelected == true) {
            widget.workingSkillStringList.add(widget.title);
            print(widget.workingSkillStringList);
          } else {
            widget.workingSkillStringList
                .removeAt(widget.workingSkillStringList.indexOf(widget.title));
            print(widget.workingSkillStringList);
          }
        });
      },
      selectedColor: Colors.pink,
      checkmarkColor: Colors.black,
    );
  }
}

class LanguageChips extends StatefulWidget {
  @override
  _LanguageChipsState createState() => _LanguageChipsState();
  final String title;
  bool isSelected;
  List<String> languageStringList;

  LanguageChips({this.title, this.languageStringList, this.isSelected});
}

class _LanguageChipsState extends State<LanguageChips> {
  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.isSelected;
    if (isSelected) {
      widget.languageStringList.add(widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(widget.title),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selected: isSelected,
      onSelected: (selected) {
        this.setState(() {
          isSelected = selected;
          if (isSelected == true) {
            widget.languageStringList.add(widget.title);
            print(widget.languageStringList);
          } else {
            widget.languageStringList
                .removeAt(widget.languageStringList.indexOf(widget.title));
            print(widget.languageStringList);
          }
        });
      },
      selectedColor: Colors.pink,
      checkmarkColor: Colors.black,
    );
  }
}
