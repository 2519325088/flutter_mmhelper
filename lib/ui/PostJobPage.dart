import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/PostJobModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/widgets/CupertinoActionSheetActionWidget.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/ChipsWidget.dart';
import 'widgets/CustomPopup.dart';

class PostJobPage extends StatefulWidget {
  @override
  _PostJobPageState createState() => _PostJobPageState();
  final String currentUserId;

  PostJobPage({this.currentUserId});
}

class _PostJobPageState extends State<PostJobPage> with AfterInitMixin {
  TextEditingController jobShortDesCtr = TextEditingController();
  TextEditingController workingLocationDesCtr = TextEditingController();
  TextEditingController availableInCtr = TextEditingController();
  TextEditingController availableTimeCtr = TextEditingController();
  TextEditingController salaryCtr = TextEditingController();
  TextEditingController unitSizeCtr = TextEditingController();
  TextEditingController moreJobDesCtr = TextEditingController();
  TextEditingController workingSkillCtr = TextEditingController();
  TextEditingController contractTypeCtr = TextEditingController();
  TextEditingController jobTypeCtr = TextEditingController();
  TextEditingController currencyTypeCtr = TextEditingController();
  TextEditingController accommodationCtr = TextEditingController();
  TextEditingController weeklyHolidayCtr = TextEditingController();
  TextEditingController languageCtr = TextEditingController();
  TextEditingController workWithCtr = TextEditingController();
  String contractType;
  String jobType;
  String currencyType;
  String accommodation;
  String weeklyHoliday;
  DateTime _date;
  final _service = FirestoreService.instance;
  PostJob postJob = PostJob();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataList> listContractData = [];
  List<DataList> listQuitReasonData = [];
  List<Widget> contractWidget = [];
  List<DataList> listJobTypeData = [];
  List<Widget> jobTypeWidget = [];
  List<DataList> listAccommodationData = [];
  List<Widget> accommodationWidget = [];
  List<DataList> listWeekHolidayData = [];
  List<Widget> weekHolidayWidget = [];
  String languageCode;
  List<Widget> workingSkillWidget = [];
  List<String> workingSkillStringList = [];
  List<DataList> listWorkSkillData = [];
  List<Widget> languageWidget = [];
  List<DataList> listLangData = [];
  List<Widget> referenceWidget = [];
  List<String> languageStringList = [];
  List<String> contractStringList = [];
  List<String> weekHolidayStringList = [];
  TimeOfDay timeOfDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyTypeCtr.text = "HKD";
    postJob.currencyType = "HKD";
    fetchLanguage().then((onValue) {
      languageCode = onValue;
      setState(() {
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
      });
      listContractData.forEach((f) {
        /*contractWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              contractTypeCtr.text =
                  dataList.getValueByLanguageCode(languageCode);
              postJob.contractType = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );*/

        contractWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: contractStringList,
          isSelected: false,
        ));
        contractWidget.add(SizedBox(
          width: 5,
        ));
      });

      listQuitReasonData.forEach((f) {
        contractWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: contractStringList,
          isSelected: false,
        ));
        contractWidget.add(SizedBox(
          width: 5,
        ));
      });

      listJobTypeData.forEach((f) {
        jobTypeWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              jobTypeCtr.text = dataList.getValueByLanguageCode(languageCode);
              postJob.jobType = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });

      listAccommodationData.forEach((f) {
        accommodationWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              accommodationCtr.text =
                  dataList.getValueByLanguageCode(languageCode);
              postJob.accommodation = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });

      listWeekHolidayData.forEach((f) {
        /*weekHolidayWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              weeklyHolidayCtr.text =
                  dataList.getValueByLanguageCode(languageCode);
              postJob.weeklyHoliday = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );*/
        weekHolidayWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: weekHolidayStringList,
          isSelected: false,
        ));
        weekHolidayWidget.add(SizedBox(
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

      reference.forEach((f) {
        referenceWidget.add(
          CupertinoActionSheetAction(
            child: Text(f),
            onPressed: () {
              workWithCtr.text = f;
              postJob.workWithMaid = f;
              Navigator.pop(context);
            },
          ),
        );
      });
    });
  }

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    jobShortDesCtr.dispose();
    workingLocationDesCtr.dispose();
    availableInCtr.dispose();
    salaryCtr.dispose();
    unitSizeCtr.dispose();
    moreJobDesCtr.dispose();
    workingSkillCtr.dispose();
    contractTypeCtr.dispose();
    jobTypeCtr.dispose();
    currencyTypeCtr.dispose();
    accommodationCtr.dispose();
    weeklyHolidayCtr.dispose();
    languageCtr.dispose();
    workWithCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleText =
        TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7));
    TextStyle dataText = TextStyle(fontSize: 20);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Post a Job"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (jobShortDesCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please enter job short description")));
                } else if (contractStringList.length == 0) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select contract type")));
                } else if (languageStringList.length == 0) {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please select preferred language")));
                } else if (workingLocationDesCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please enter working location")));
                } else if (jobTypeCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select job type")));
                } else if (_date == null) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select available in")));
                } else if (currencyTypeCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select currency type")));
                } else if (salaryCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please enter salary amount")));
                } else if (unitSizeCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please enter unit size")));
                } else if (int.parse(unitSizeCtr.text) < 100 ||
                    int.parse(unitSizeCtr.text) > 5000) {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Unit should be between 100 to 5000")));
                } else if (workWithCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please select work with other maid?")));
                } else if (accommodationCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select accommodation")));
                } else if (weekHolidayStringList.length == 0) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select weekly holiday")));
                } else if (workingSkillStringList.length == 0) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Select working skill")));
                } else if (moreJobDesCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please enter more job description")));
                } else {
                  String workingSkillString = "";
                  String preferredLangString = "";
                  String contractString = "";
                  String weekHolidayString = "";
                  workingSkillStringList.forEach((f) {
                    workingSkillString += "$f;";
                  });
                  languageStringList.forEach((f) {
                    preferredLangString += "$f;";
                  });
                  contractStringList.forEach((f) {
                    contractString += "$f;";
                  });
                  weekHolidayStringList.forEach((f) {
                    weekHolidayString += "$f;";
                  });
                  postJob.skillRequirement = workingSkillString;
                  postJob.preferredLang = preferredLangString;
                  postJob.contractType = contractString;
                  postJob.weeklyHoliday = weekHolidayString;

//                  String id = DateTime.now().toIso8601String();
                  postJob.id = "";
                  postJob.userId = widget.currentUserId;
                  postJob.createTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      TimeOfDay.now().hour,
                      TimeOfDay.now().minute);
                  Firestore.instance.collection("fl_job_post").add(postJob.toMap()).then((datas){
                    postJob.id = datas.documentID;
                    _service.addData(path: APIPath.newJob(datas.documentID),
                        data: postJob.toMap())
                        .then((onValue) async {
                      //Navigator.pop(context);
                      await showDialog<String>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return CustomPopup(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              title: "Job created",
                              message:
                              "Your job is posted! Please turn on notification and Check the replies in the message box 😎",
                            );
                          });
                    });
                  });
//                  _service
//                      .addData(path: APIPath.newJob(id), data: postJob.toMap())
//                      .then((onValue) async {
//                    //Navigator.pop(context);
//                    await showDialog<String>(
//                        context: context,
//                        barrierDismissible: false,
//                        builder: (BuildContext context) {
//                          return CustomPopup(
//                            onTap: () {
//                              Navigator.pop(context);
//                              Navigator.pop(context);
//                            },
//                            title: "Job created",
//                            message:
//                                "Your job is posted! Please turn on notification and Check the replies in the message box 😎",
//                          );
//                        });
//                  });
                }
              })
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Job Short Description:",
                          style: titleText,
                        ),
                        TextFormField(
                          controller: jobShortDesCtr,
                          style: dataText,
                          onChanged: (value) {
                            postJob.jobShortDescription = value;
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.of(context).translate('Contract_Status')}:",
                                    style: titleText,
                                  ),
                                  Wrap(children: contractWidget)
                                  /*TextFormField(
                                    style: dataText,
                                    controller: contractTypeCtr,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(
                                                'Select_Contract_Status')),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .translate('Contract_Status'),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          AppLocalizations.of(context)
                                              .translate('Select_any_option'),
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: contractWidget,
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                              AppLocalizations.of(context)
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
                                  )*/
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
                              Icons.language,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.of(context).translate('Preferred_Language')}:",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Working Location:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    onChanged: (newValue) {
                                      postJob.workingLocation = newValue;
                                    },
                                    controller: workingLocationDesCtr,
                                    style: dataText,
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
                              Icons.category,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.of(context).translate('Job_Type')}:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    style: dataText,
                                    controller: jobTypeCtr,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate('Select_Job_Type')),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .translate('Job_Type'),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          AppLocalizations.of(context)
                                              .translate('Select_any_option'),
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: jobTypeWidget,
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                              AppLocalizations.of(context)
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
                              Icons.calendar_today,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Expected Start Working date:",
                                    style: titleText,
                                  ),
                                  GestureDetector(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Select available in date"),
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        _selectDate(context);
                                      },
                                      controller: availableInCtr,
                                      style: dataText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        /*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Available Time:",
                                    style: titleText,
                                  ),
                                  GestureDetector(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Select available time"),
                                      onTap: () {
                                        if (_date != null) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _selectTime(context);
                                        } else {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          scaffoldKey.currentState.showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "First select available in")));
                                        }
                                      },
                                      controller: availableTimeCtr,
                                      style: dataText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),*/
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Salary:",
                                    style: titleText,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                          child:
                                              /*DropdownButtonFormField<String>(
                                          items: [
                                            DropdownMenuItem<String>(
                                              child: Text(
                                                "HKD",
                                                style: dataText,
                                              ),
                                              value: "HKD",
                                            ),
                                            DropdownMenuItem<String>(
                                              child: Text(
                                                "USD",
                                                style: dataText,
                                              ),
                                              value: "USD",
                                            ),
                                          ],
                                          hint: Text(
                                            "Unselected",
                                            style: dataText,
                                          ),
                                          onChanged: (newValue) {
                                            postJob.currencyType = newValue;
                                            setState(() {
                                              currencyType = newValue;
                                            });
                                          },
                                          value: currencyType,
                                        ),*/
                                              TextFormField(
                                        style: dataText,
                                        controller: currencyTypeCtr,
                                        decoration: InputDecoration(
                                            hintText: "Currency"),
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          final action = CupertinoActionSheet(
                                            title: Text(
                                              "Currency Type",
                                              style: TextStyle(fontSize: 30),
                                            ),
                                            message: Text(
                                              "Select any option ",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: Text("HKD"),
                                                onPressed: () {
                                                  currencyTypeCtr.text = "HKD";
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text("USD"),
                                                onPressed: () {
                                                  currencyTypeCtr.text = "USD";
                                                  Navigator.pop(context);
                                                },
                                              ),
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
                                      )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          child: TextFormField(
                                            onChanged: (newValue) {
                                              postJob.salary = newValue;
                                            },
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false),
                                            decoration: InputDecoration(
                                              hintText: "amount",
                                            ),
                                            controller: salaryCtr,
                                            style: dataText,
                                          ),
                                        ),
                                      ),
                                    ],
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
                              Icons.home,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Unit Size (Sq Feet):",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    onChanged: (newValue) {
                                      postJob.unitSize = newValue;
                                    },
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: false),
                                    controller: unitSizeCtr,
                                    style: dataText,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Work With Other maid:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    style: dataText,
                                    controller: workWithCtr,
                                    decoration: InputDecoration(
                                        hintText: "Select Option"),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          "Work With Other maid",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          "Select any option ",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: referenceWidget,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.of(context).translate('accommodation')}:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    style: dataText,
                                    controller: accommodationCtr,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate('Select_accommodation')),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .translate('accommodation'),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          AppLocalizations.of(context)
                                              .translate('Select_any_option'),
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: accommodationWidget,
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                              AppLocalizations.of(context)
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${AppLocalizations.of(context).translate('weekly_holiday')}:",
                                    style: titleText,
                                  ),
                                  Wrap(children: weekHolidayWidget)
                                  /*TextFormField(
                                    style: dataText,
                                    controller: weeklyHolidayCtr,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(
                                                'Select_weekly_holiday')),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          AppLocalizations.of(context)
                                              .translate('weekly_holiday'),
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          AppLocalizations.of(context)
                                              .translate('Select_any_option'),
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: weekHolidayWidget,
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                              AppLocalizations.of(context)
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
                                  )*/
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
                              Icons.library_books,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Icons.description,
                              color: Colors.black54,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "More Job Description:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    onChanged: (newValue) {
                                      postJob.moreDescription = newValue;
                                    },
                                    controller: moreJobDesCtr,
                                    style: dataText,
                                    maxLines: 5,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        availableInCtr.text = DateFormat.yMMMMEEEEd().format(_date);
        postJob.available = _date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeOfDay = picked;
        availableTimeCtr.text = timeOfDay.format(context);
        final dt = DateTime(_date.year, _date.month, _date.day, timeOfDay.hour,
            timeOfDay.minute);
        // postJob.availableTime = dt;
      });
    }
  }

  @override
  void didInitState() {
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();
    var appLanguage = Provider.of<DataListService>(context);
    listQuitReasonData = appLanguage.listQuitReasonData;
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listAccommodationData = appLanguage.listAccommodationData;
    listWeekHolidayData = appLanguage.listWeekHolidayData;
    listWorkSkillData = appLanguage.listWorkSkillData;
    listLangData = appLanguage.listLangData;
  }
}
