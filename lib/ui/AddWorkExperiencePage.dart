import 'package:after_init/after_init.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/widgets/ChipsWidget.dart';
import 'package:flutter_mmhelper/ui/widgets/CountryListPopup.dart';
import 'package:flutter_mmhelper/ui/widgets/CupertinoActionSheetActionWidget.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkExperiencePage extends StatefulWidget {
  @override
  _AddWorkExperiencePageState createState() => _AddWorkExperiencePageState();
  final ValueChanged<Workexperience> onChanged;
  Workexperience oldWorkExperience;
  String currentLoc;

  AddWorkExperiencePage(
      {this.onChanged, this.oldWorkExperience, this.currentLoc});
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage>
    with AfterInitMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController countryCtr = TextEditingController();
  TextEditingController startDateCtr = TextEditingController();
  TextEditingController endDateCtr = TextEditingController();
  TextEditingController jobTypeCtr = TextEditingController();
  TextEditingController reasonCtr = TextEditingController();
  TextEditingController referenceCtr = TextEditingController();
  TextEditingController takenCtr = TextEditingController();
  DateTime startDate;
  DateTime endDate;
  List<Widget> jobTypeWidget = [];
  List<Widget> reasonWidget = [];
  List<Widget> referenceWidget = [];
  List<Widget> takenWidget = [];
  Workexperience workExperience = Workexperience();
  List<Widget> workingSkillWidget = [];
  List<String> workingSkillStringList = [];
  List<DataList> listWorkSkillData = [];
  List<DataList> quitReasonData = [];
  List<DataList> quitReasonHkData = [];
  List<DataList> listJobTypeData = [];
  String languageCode;

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLanguage().then((nLanguageCode) {
      languageCode = nLanguageCode;
      if (widget.oldWorkExperience != null) {
        countryCtr.text = widget.oldWorkExperience.country;
        workExperience.country = widget.oldWorkExperience.country;
        workExperience.start = widget.oldWorkExperience.start;
        startDateCtr.text =
            DateFormat.yMMMMEEEEd().format(widget.oldWorkExperience.start);
        workExperience.end = widget.oldWorkExperience.end;
        endDateCtr.text =
            DateFormat.yMMMMEEEEd().format(widget.oldWorkExperience.end);
        workExperience.jobtype = widget.oldWorkExperience.jobtype;
        //jobTypeCtr.text = widget.oldWorkExperience.jobtype;
        takenCtr.text = widget.oldWorkExperience.taken;
        workExperience.taken = widget.oldWorkExperience.taken;
        referenceCtr.text = widget.oldWorkExperience.reterence;
        workExperience.reterence = widget.oldWorkExperience.reterence;
        //reasonCtr.text = widget.oldWorkExperience.reason;
        workExperience.reason = widget.oldWorkExperience.reason;
        startDate = widget.oldWorkExperience.start;
        endDate = widget.oldWorkExperience.end;
        List<String> oldSkill = widget.oldWorkExperience.taken.split(",");
        oldSkill.forEach((element) {
          workingSkillStringList.add(element);
        });

        listWorkSkillData.forEach((f) {
          workingSkillWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: workingSkillStringList,
              isSelected: oldSkill.contains(f.nameId)));
          workingSkillWidget.add(SizedBox(
            width: 5,
          ));
        });

        setState(() {});
      }

      widget.currentLoc != "Hong Kong"
          ? quitReasonData.forEach((f) {
              if (widget.oldWorkExperience != null) {
                reasonCtr.text = f.getValueByLanguageCode(languageCode);
                workExperience.reason = f.nameId;
              }

              reasonWidget.add(
                CupertinoActionSheetActionWidget(
                  languageCode: languageCode,
                  dataList: f,
                  onPressedCall: (dataList) {
                    reasonCtr.text =
                        dataList.getValueByLanguageCode(languageCode);
                    workExperience.reason = dataList.nameId;
                    Navigator.pop(context);
                  },
                ),
              );
            })
          : quitReasonHkData.forEach((f) {
              if (widget.oldWorkExperience != null) {
                reasonCtr.text = f.getValueByLanguageCode(languageCode);
                workExperience.reason = f.nameId;
              }
              reasonWidget.add(
                CupertinoActionSheetActionWidget(
                  languageCode: languageCode,
                  dataList: f,
                  onPressedCall: (dataList) {
                    reasonCtr.text =
                        dataList.getValueByLanguageCode(languageCode);
                    workExperience.reason = dataList.nameId;
                    Navigator.pop(context);
                  },
                ),
              );
            });

      /*jobtype.forEach((f) {
        jobTypeWidget.add(
          CupertinoActionSheetAction(
            child: Text(f),
            onPressed: () {
              jobTypeCtr.text = f;
              workExperience.jobtype = f;
              Navigator.pop(context);
            },
          ),
        );
      });*/
      listJobTypeData.forEach((f) {
        if (widget.oldWorkExperience != null) {
          jobTypeCtr.text = f.getValueByLanguageCode(languageCode);
          workExperience.jobtype = f.nameId;
        }
        jobTypeWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              jobTypeCtr.text = dataList.getValueByLanguageCode(languageCode);
              workExperience.jobtype = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });
      reference.forEach((f) {
        referenceWidget.add(
          CupertinoActionSheetAction(
            child: Text(f),
            onPressed: () {
              referenceCtr.text = f;
              workExperience.reterence = f;
              Navigator.pop(context);
            },
          ),
        );
      });
      if (widget.oldWorkExperience == null) {
        fetchLanguage().then((onValue) {
          languageCode = onValue;
          setState(() {
            listWorkSkillData.forEach((f) {
              workingSkillWidget.add(ChipsWidget(
                  languageCode: languageCode,
                  dataList: f,
                  typeStringList: workingSkillStringList,
                  isSelected: false));
              workingSkillWidget.add(SizedBox(
                width: 5,
              ));
            });
          });
        });
      }
    });
  }

  onCountryChange(String country) {
    setState(() {
      countryCtr.text = country;
      workExperience.country = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cardTitleText = TextStyle(fontSize: 20, color: Colors.black);
    TextStyle titleText =
        TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7));
    TextStyle dataText = TextStyle(fontSize: 20);
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: widget.oldWorkExperience == null
            ? Text("Add Work Experience")
            : Text("Update Work Experience"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (countryCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select country")));
                } else if (startDate == null) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select start date")));
                } else if (endDate == null) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select end date")));
                } else if (startDate.isAfter(endDate)) {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("start date is not after end date")));
                } else if (jobTypeCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select job type")));
                } else if (workingSkillStringList.length == 0) {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select working skill")));
                } else if (reasonCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select Quit Reason")));
                } else if (referenceCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select reference")));
                } else {
                  String taken = "";
                  workingSkillStringList.forEach((element) {
                    taken += "$element,";
                  });
                  workExperience.taken = taken.substring(0, taken.length - 1);
                  widget.onChanged(workExperience);
                  Navigator.pop(context);
                }
              })
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Country:",
                                      style: titleText,
                                    ),
                                    TextFormField(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StateListPopup(
                                                onChanged: onCountryChange,
                                                isFromWorkProfile: true,
                                              );
                                            });
                                      },
                                      controller: countryCtr,
                                      style: dataText,
                                      decoration: InputDecoration(
                                          hintText: "Enter country"),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Start Date:",
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
                                            startDate = date;
                                          });
                                          startDateCtr.text =
                                              DateFormat.yMMMMEEEEd()
                                                  .format(startDate);
                                          workExperience.start = startDate;
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      controller: startDateCtr,
                                      style: dataText,
                                      decoration: InputDecoration(
                                          hintText: "Select start date"),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "End Date:",
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
                                            endDate = date;
                                          });
                                          endDateCtr.text =
                                              DateFormat.yMMMMEEEEd()
                                                  .format(endDate);
                                          workExperience.end = endDate;
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                                      controller: endDateCtr,
                                      style: dataText,
                                      decoration: InputDecoration(
                                          hintText: "Select end date"),
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
                                        final action = CupertinoActionSheet(
                                          title: Text(
                                            "Job Type",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          message: Text(
                                            "Select any option ",
                                            style: TextStyle(fontSize: 15.0),
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
                                      "Quit Reason:",
                                      style: titleText,
                                    ),
                                    TextFormField(
                                      style: dataText,
                                      controller: reasonCtr,
                                      decoration: InputDecoration(
                                          hintText: "Select quit reason"),
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        final action = CupertinoActionSheet(
                                          title: Text(
                                            "Quit Reason",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          message: Text(
                                            "Select any option ",
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                          actions: reasonWidget,
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
                                      "Reference Letter:",
                                      style: titleText,
                                    ),
                                    TextFormField(
                                      style: dataText,
                                      controller: referenceCtr,
                                      decoration: InputDecoration(
                                          hintText: "Select Reference Letter"),
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        final action = CupertinoActionSheet(
                                          title: Text(
                                            "Reference Letter",
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
    );
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 21900)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        startDateCtr.text = DateFormat.yMMMMEEEEd().format(startDate);
        workExperience.start = startDate;
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 21900)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        endDateCtr.text = DateFormat.yMMMMEEEEd().format(endDate);
        workExperience.end = endDate;
      });
    }
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    var appLanguage = Provider.of<DataListService>(context);
    listWorkSkillData = appLanguage.listWorkSkillData;
    quitReasonData = appLanguage.listQuitReasonData;
    quitReasonHkData = appLanguage.listQuitReasonHkData;
    listJobTypeData = appLanguage.listJobTypeData;
  }
}
