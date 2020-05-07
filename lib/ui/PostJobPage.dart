import 'package:after_init/after_init.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController salaryCtr = TextEditingController();
  TextEditingController unitSizeCtr = TextEditingController();
  TextEditingController moreJobDesCtr = TextEditingController();
  TextEditingController skillCtr = TextEditingController();
  TextEditingController contractTypeCtr = TextEditingController();
  TextEditingController jobTypeCtr = TextEditingController();
  TextEditingController currencyTypeCtr = TextEditingController();
  TextEditingController accommodationCtr = TextEditingController();
  TextEditingController weeklyHolidayCtr = TextEditingController();
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
  List<Widget> contractWidget = [];
  List<DataList> listJobTypeData = [];
  List<Widget> jobTypeWidget = [];
  List<DataList> listAccommodationData = [];
  List<Widget> accommodationWidget = [];
  List<DataList> listWeekHolidayData = [];
  List<Widget> weekHolidayWidget = [];
  String languageCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyTypeCtr.text = "HKD";

    fetchLanguage().then((onValue) {
      languageCode = onValue;

      listContractData.forEach((f) {
        contractWidget.add(
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
        );
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
              accommodationCtr.text = dataList.getValueByLanguageCode(languageCode);
              postJob.accommodation = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });

      listWeekHolidayData.forEach((f) {
        weekHolidayWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              weeklyHolidayCtr.text = dataList.getValueByLanguageCode(languageCode);
              postJob.weeklyHoliday = dataList.nameId;
              print(dataList.nameId);
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
    skillCtr.dispose();
    contractTypeCtr.dispose();
    jobTypeCtr.dispose();
    currencyTypeCtr.dispose();
    accommodationCtr.dispose();
    weeklyHolidayCtr.dispose();
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
              onPressed: () {
                if (jobShortDesCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please enter job short description")));
                } else if (contractTypeCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select contract type")));
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
                } else if (accommodationCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select accommodation")));
                } else if (weeklyHolidayCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Please select weekly holiday")));
                } else if (moreJobDesCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please enter more job description")));
                } else if (skillCtr.text == "") {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Please enter skill requirements")));
                } else {
                  String id = DateTime.now().toIso8601String();
                  postJob.id = id;
                  postJob.userId = widget.currentUserId;
                  _service
                      .setData(path: APIPath.newJob(id), data: postJob.toMap())
                      .then((onValue) {
                    Navigator.pop(context);
                  });
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
                                  TextFormField(
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
                                    "Available In:",
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
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
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
                                    "${AppLocalizations.of(context).translate('accommodation')}:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    style: dataText,
                                    controller: accommodationCtr,
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(
                                            'Select_accommodation')),
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
                                  TextFormField(
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
                                    "Skill Requirements:",
                                    style: titleText,
                                  ),
                                  TextFormField(
                                    onChanged: (newValue) {
                                      postJob.skillRequirement = newValue;
                                    },
                                    controller: skillCtr,
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
      firstDate: DateTime.now().subtract(Duration(days: 1)),
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

  @override
  void didInitState() {
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();

    var appLanguage = Provider.of<DataListService>(context);
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listAccommodationData = appLanguage.listAccommodationData;
    listWeekHolidayData = appLanguage.listWeekHolidayData;
  }
}
