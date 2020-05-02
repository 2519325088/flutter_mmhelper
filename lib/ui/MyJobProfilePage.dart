import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/AddWorkExperiencePage.dart';
import 'package:flutter_mmhelper/ui/widgets/ChipsWidget.dart';
import 'package:flutter_mmhelper/ui/widgets/CupertinoActionSheetActionWidget.dart';
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

  String languageCode;

  List<String> workingSkillStringList = [];
  List<String> languageStringList = [];

  List<DataList> listEducationData = [];
  List<DataList> listReligionData = [];
  List<DataList> listMaritalData = [];
  List<DataList> listChildrenData = [];
  List<DataList> listJobTypeData = [];
  List<DataList> listJobCapData = [];
  List<DataList> listContractData = [];
  List<DataList> listWorkSkillData = [];
  List<DataList> listLangData = [];

  List<Asset> imagesa = List<Asset>();
  final _service = FirestoreService.instance;
  QuerySnapshot profileQuerySnapshot;
  ScrollController scrollController = ScrollController();
  bool isEdit = false;
  int exIndex;

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  Future<QuerySnapshot> getMyJobProfile() async {
    return await Firestore.instance
        .collection("mb_profile")
        .where("id", isEqualTo: widget.userId)
        .getDocuments();
  }

  @override
  void initState() {
    super.initState();
    profileData.imagelist = [];
    profileData.workexperiences = [];

    fetchLanguage().then((onValue) {
      languageCode = onValue;

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
          profileData.birthday =
              DateTime.parse(onValue.documents[0]["birthday"]);
          nationalityCtr.text = onValue.documents[0]["nationaity"];
          profileData.nationaity = onValue.documents[0]["nationaity"];

          locationCtr.text = onValue.documents[0]["current"];
          profileData.current = onValue.documents[0]["current"];
          whatsAppCtr.text = onValue.documents[0]["whatsapp"];
          profileData.whatsapp = onValue.documents[0]["whatsapp"];
          phoneCtr.text = onValue.documents[0]["phone"];
          profileData.phone = onValue.documents[0]["phone"];

          expectedSalaryCtr.text = onValue.documents[0]["expectedsalary"];
          profileData.expectedsalary = onValue.documents[0]["expectedsalary"];
          startDateCtr.text = DateFormat.yMMMMEEEEd()
              .format(DateTime.parse(onValue.documents[0]["employment"]));
          profileData.employment =
              DateTime.parse(onValue.documents[0]["employment"]);
          selfCtr.text = onValue.documents[0]["selfintroduction"];
          profileData.selfintroduction =
              onValue.documents[0]["selfintroduction"];

          listWorkSkillData.forEach((f) {
            workingSkillWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: workingSkillStringList,
              isSelected: onValue.documents[0]["workskill"]
                  .toString()
                  .contains(f.nameEn),
            ));
            workingSkillWidget.add(SizedBox(
              width: 5,
            ));
          });

          listLangData.forEach((f) {
            languageWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: languageStringList,
              isSelected: onValue.documents[0]["language"]
                  .toString()
                  .contains(f.nameEn),
            ));
            languageWidget.add(SizedBox(
              width: 5,
            ));
          });

          listEducationData.forEach((f) {
            if (onValue.documents[0]["education"]
                .toString()
                .contains(f.nameEn)) {
              eduCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.education = f.nameEn;
            }
            eduWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  eduCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.education = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listReligionData.forEach((f) {
            if (onValue.documents[0]["religion"]
                .toString()
                .contains(f.nameEn)) {
              religionCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.religion = f.nameEn;
            }
            religionWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  religionCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.religion = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listMaritalData.forEach((f) {
            if (onValue.documents[0]["marital"].toString().contains(f.nameEn)) {
              maritalCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.marital = f.nameEn;
            }
            maritalStatusWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  maritalCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.marital = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listChildrenData.forEach((f) {
            if (onValue.documents[0]["children"]
                .toString()
                .contains(f.nameEn)) {
              childCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.children = f.nameEn;
            }
            childrenWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  childCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.children = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobTypeData.forEach((f) {
            if (onValue.documents[0]["jobtype"].toString().contains(f.nameEn)) {
              jobTypeCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.jobtype = f.nameEn;
            }
            jobTypeWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobTypeCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobtype = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobCapData.forEach((f) {
            if (onValue.documents[0]["jobcapacity"]
                .toString()
                .contains(f.nameEn)) {
              jobCapCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.jobcapacity = f.nameEn;
            }
            jobCapWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobCapCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobcapacity = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listContractData.forEach((f) {
            if (onValue.documents[0]["contract"]
                .toString()
                .contains(f.nameEn)) {
              contractCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.contract = f.nameEn;
            }
            contractWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  contractCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.contract = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          setState(() {});

          onValue.documents[0]["workexperiences"].forEach((f) {
            profileData.workexperiences.add(Workexperience.fromMap((f)));
          });
          onValue.documents[0]["imagelist"].forEach((f) {
            profileData.imagelist.add(f);
          });
          profileData.primaryImage = onValue.documents[0]["primaryimage"];
        } else {
          listWorkSkillData.forEach((f) {
            workingSkillWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: workingSkillStringList,
              isSelected: false,
            ));
            workingSkillWidget.add(SizedBox(
              width: 5,
            ));
          });

          listLangData.forEach((f) {
            languageWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: languageStringList,
              isSelected: false,
            ));
            languageWidget.add(SizedBox(
              width: 5,
            ));
          });

          listEducationData.forEach((f) {
            eduWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  eduCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.education = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listReligionData.forEach((f) {
            religionWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  religionCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.religion = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listMaritalData.forEach((f) {
            maritalStatusWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  maritalCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.marital = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listChildrenData.forEach((f) {
            childrenWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  childCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.children = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobTypeData.forEach((f) {
            jobTypeWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobTypeCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobtype = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobCapData.forEach((f) {
            jobCapWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobCapCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobcapacity = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listContractData.forEach((f) {
            contractWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  contractCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.contract = dataList.nameEn;
                  print(dataList.nameEn);
                  Navigator.pop(context);
                },
              ),
            );
          });

          setState(() {});
        }
      });
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
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    ByteData byteData = await asset.getByteData();
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
        title: Text(AppLocalizations.of(context).translate('My_Job_Profile')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (isLoading == false) {
                  if (firstNameCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_firstname'))));
                  } else if (lastNameCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_lastname'))));
                  } else if (genderCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_gender'))));
                  } else if (birthDayCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_birth_date'))));
                  } else if (nationalityCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_nationality'))));
                  } else if (eduCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_education'))));
                  } else if (religionCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_religion'))));
                  } else if (maritalCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_marital_status'))));
                  } else if (childCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_child'))));
                  } else if (locationCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_location'))));
                  } else if (whatsAppCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_whatsapp_number'))));
                  } else if (phoneCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_phone'))));
                  } else if (jobTypeCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_job_type'))));
                  } else if (jobCapCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_job_capacity'))));
                  } else if (contractCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_contract'))));
                  } else if (workingSkillStringList.length == 0) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_working_skill'))));
                  } else if (languageStringList.length == 0) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_language'))));
                  } else if (expectedSalaryCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_expected_salary'))));
                  } else if (startDateCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context).translate(
                            'Please_select_employement_start_date'))));
                  } else if (selfCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_self_introduction'))));
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    String workingSkillString = "";
                    String languageString = "";
                    workingSkillStringList.forEach((f) {
                      workingSkillString += "$f;";
                    });
                    languageStringList.forEach((f) {
                      languageString += "$f;";
                    });
                    print("Upload education ${profileData.education}");
                    profileData.workskill = workingSkillString;
                    profileData.language = languageString;
                    profileData.id = DateTime.parse(widget.userId);
                    int i = 1;
                    if (imagesa.length != 0) {
                      imagesa.forEach((upFile) async {
                        String downloadLink = await saveImage(upFile);
                        profileData.imagelist.add(downloadLink);
                        print("Upload in count $i");
                        i += 1;
                        if (i > imagesa.length) {
                          print("Profile update call");
                          if (profileData.primaryImage == null) {
                            profileData.primaryImage = profileData.imagelist[0];
                          }
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
                                content: Text(AppLocalizations.of(context)
                                    .translate(
                                        'Profile_Update_Successfully'))));
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
                              content: Text(AppLocalizations.of(context)
                                  .translate('Profile_Update_Successfully'))));
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)
                                .translate('Please_select_Image'))));
                      }
                    }
                  }
                } else {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate('Wait_data_is_updating'))));
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
                                  AppLocalizations.of(context)
                                      .translate('Basic_Information'),
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
                                            "${AppLocalizations.of(context).translate('FirstName')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.firstname = newValue;
                                            },
                                            controller: firstNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_first_name')),
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
                                            "${AppLocalizations.of(context).translate('LastName')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.lastname = newValue;
                                            },
                                            controller: lastNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Enter_last_name')),
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
                                            "${AppLocalizations.of(context).translate('Gender')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: genderCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Gender')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Gender'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate('Male')),
                                                    onPressed: () {
                                                      genderCtr.text =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Male');
                                                      profileData.gender =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Male');
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text(AppLocalizations
                                                            .of(context)
                                                        .translate('Female')),
                                                    onPressed: () {
                                                      genderCtr.text =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Female');
                                                      profileData.gender =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Female');
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Birthday')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(1950, 1, 1),
                                                  maxTime: DateTime.now(),
                                                  /* onChanged: (date) {
                                                    setState(() {
                                                      birthDayDate = date;
                                                    });
                                                    birthDayCtr.text = DateFormat.yMMMMEEEEd().format(birthDayDate);
                                                    profileData.birthday = birthDayDate;
                                                  },*/
                                                  onConfirm: (date) {
                                                setState(() {
                                                  birthDayDate = date;
                                                });
                                                birthDayCtr.text =
                                                    DateFormat.yMMMMEEEEd()
                                                        .format(birthDayDate);
                                                profileData.birthday =
                                                    birthDayDate;
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                            },
                                            controller: birthDayCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Birthday')),
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
                                            "${AppLocalizations.of(context).translate('Nationality')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.nationaity = newText;
                                            },
                                            controller: nationalityCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_nationality')),
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
                                  AppLocalizations.of(context)
                                      .translate('Detail_Information'),
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
                                            "${AppLocalizations.of(context).translate('Education')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: eduCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Education')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Education'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: eduWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Religion')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: religionCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Religion')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Religion'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: religionWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Marital_Status')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: maritalCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Marital_Status')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Marital_Status'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: maritalStatusWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Children')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: childCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Children')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Children'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: childrenWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Current_Location')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newText) {
                                              profileData.current = newText;
                                            },
                                            controller: locationCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_current_location')),
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
                                            "${AppLocalizations.of(context).translate('Whatsapp_Number')}:",
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
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_whatsapp_number')),
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
                                            "${AppLocalizations.of(context).translate('Phone_Number_verified')}:",
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
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_Phone_number')),
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
                                  AppLocalizations.of(context)
                                      .translate('Work_Information'),
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
                                            "${AppLocalizations.of(context).translate('Job_Type')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobTypeCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Job_Type')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Job_Type'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobTypeWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Job_Capacity')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobCapCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Job_Capacity')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Job_Capacity'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobCapWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Contract_Status')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: contractCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Contract_Status')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Contract_Status'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: contractWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                            "${AppLocalizations.of(context).translate('Working_Skill')}:",
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
                                            "${AppLocalizations.of(context).translate('Language')}:",
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
                                            "${AppLocalizations.of(context).translate('Expected_Salary_HKD')}:",
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
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_expected_salary')),
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
                                            "${AppLocalizations.of(context).translate('Employement_Start_Date')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime.now(),
                                                  maxTime:
                                                      DateTime(2030, 12, 31),
                                                  onConfirm: (date) {
                                                setState(() {
                                                  startDate = date;
                                                });
                                                startDateCtr.text =
                                                    DateFormat.yMMMMEEEEd()
                                                        .format(startDate);
                                                profileData.employment =
                                                    startDate;
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                            },
                                            controller: startDateCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate('Select_Date')),
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
                                      AppLocalizations.of(context)
                                          .translate('Work_Experience'),
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
                                    AppLocalizations.of(context)
                                        .translate('Add_your_work_experince'),
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
                                  AppLocalizations.of(context)
                                      .translate('Self_Introduction'),
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
                                      hintText: AppLocalizations.of(context)
                                          .translate(
                                              'Enter_self_introduction')),
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
                                  AppLocalizations.of(context)
                                      .translate('Image_Introduction'),
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
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      profileData.primaryImage != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Primary_Image'),
                                                    style: titleText,
                                                  ),
                                                ),
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      profileData.primaryImage,
                                                  height: 110,
                                                  width: 110,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                              ],
                                            )
                                          : SizedBox(),
                                      profileData.imagelist.length != 0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Server_Image'),
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
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Local_Image'),
                                                    style: titleText,
                                                  ),
                                                ),
                                                imagesa.length != 0
                                                    ? buildGridView()
                                                    : Text(""),
                                              ],
                                            )
                                          : SizedBox(),
                                      Align(
                                        alignment: Alignment.center,
                                        child: RaisedButton(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('Pick_images')),
                                          onPressed: loadAssets,
                                        ),
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
            GestureDetector(
              onTap: () {
                setState(() {
                  profileData.primaryImage = profileData.imagelist[index];
                });
              },
              child: CachedNetworkImage(
                imageUrl: profileData.imagelist[index],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
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
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();

    var appLanguage = Provider.of<DataListService>(context);
    listEducationData = appLanguage.listEducationData;
    listReligionData = appLanguage.listReligionData;
    listMaritalData = appLanguage.listMaritalData;
    listChildrenData = appLanguage.listChildrenData;
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listJobCapData = appLanguage.listJobCapData;
    listWorkSkillData = appLanguage.listWorkSkillData;
    listLangData = appLanguage.listLangData;
  }
}
