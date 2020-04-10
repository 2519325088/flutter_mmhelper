import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/Models/PostJobModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostJobPage extends StatefulWidget {
  @override
  _PostJobPageState createState() => _PostJobPageState();
  final String currentUserId;

  PostJobPage({this.currentUserId});
}

class _PostJobPageState extends State<PostJobPage> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyTypeCtr.text = "HKD";
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
                                    "Contract Type:",
                                    style: titleText,
                                  ),
                                  /*DropdownButtonFormField<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Contract Type 1",
                                          style: dataText,
                                        ),
                                        value: "Contract Type 1",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Contract Type 2",
                                          style: dataText,
                                        ),
                                        value: "Contract Type 2",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Contract Type 3",
                                          style: dataText,
                                        ),
                                        value: "Contract Type 3",
                                      )
                                    ],
                                    hint: Text(
                                      "Unselected",
                                      style: dataText,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        contractType = newValue;
                                        postJob.contractType =
                                            newValue.toString();
                                      });
                                    },
                                    value: contractType,
                                  )*/
                                  TextFormField(
                                    style: dataText,
                                    controller: contractTypeCtr,
                                    decoration: InputDecoration(
                                        hintText: "Select contract type"),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          "Contract Type",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          "Select any option ",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: Text("option 1"),
                                            onPressed: () {
                                              contractTypeCtr.text = "option 1";
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("option 2"),
                                            onPressed: () {
                                              contractTypeCtr.text = "option 2";
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
                              Icons.perm_contact_calendar,
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
                                  /*DropdownButtonFormField<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Full Time",
                                          style: dataText,
                                        ),
                                        value: "Full Time",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Part Time",
                                          style: dataText,
                                        ),
                                        value: "Part Time",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Permanent",
                                          style: dataText,
                                        ),
                                        value: "Permanent",
                                      )
                                    ],
                                    hint: Text(
                                      "Unselected",
                                      style: dataText,
                                    ),
                                    onChanged: (newValue) {
                                      postJob.jobType = newValue;

                                      setState(() {
                                        jobType = newValue;
                                      });
                                    },
                                    value: jobType,
                                  )*/
                                  TextFormField(
                                    style: dataText,
                                    controller: jobTypeCtr,
                                    decoration: InputDecoration(
                                        hintText: "Select job type"),
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
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: Text("Full Time"),
                                            onPressed: () {
                                              jobTypeCtr.text = "Full Time";
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("Part Time"),
                                            onPressed: () {
                                              jobTypeCtr.text = "Part Time";
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("Permanent"),
                                            onPressed: () {
                                              jobTypeCtr.text = "Permanent";
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
                              Icons.airline_seat_individual_suite,
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
                                    "Accommodation:",
                                    style: titleText,
                                  ),
                                  /*DropdownButtonFormField<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Shared bedroom",
                                          style: dataText,
                                        ),
                                        value: "Shared bedroom",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Private bedroom",
                                          style: dataText,
                                        ),
                                        value: "Private bedroom",
                                      ),
                                    ],
                                    hint: Text(
                                      "Unselected",
                                      style: dataText,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        accommodation = newValue;
                                        postJob.accommodation = newValue;
                                      });
                                    },
                                    value: accommodation,
                                  )*/
                                  TextFormField(
                                    style: dataText,
                                    controller: accommodationCtr,
                                    decoration: InputDecoration(
                                        hintText: "Select accommodation"),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          "Accommodation",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          "Select any option ",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: Text("Shared bedroom"),
                                            onPressed: () {
                                              accommodationCtr.text =
                                                  "Shared bedroom";
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("Private bedroom"),
                                            onPressed: () {
                                              accommodationCtr.text =
                                                  "Private bedroom";
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
                              Icons.photo_size_select_actual,
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
                                    "Weekly Holiday:",
                                    style: titleText,
                                  ),
                                  /*DropdownButtonFormField<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "1",
                                          style: dataText,
                                        ),
                                        value: "1",
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "2",
                                          style: dataText,
                                        ),
                                        value: "2",
                                      ),
                                    ],
                                    hint: Text(
                                      "Unselected",
                                      style: dataText,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        weeklyHoliday = newValue;
                                        postJob.weeklyHoliday = newValue;
                                      });
                                    },
                                    value: weeklyHoliday,
                                  )*/
                                  TextFormField(
                                    style: dataText,
                                    controller: weeklyHolidayCtr,
                                    decoration: InputDecoration(
                                        hintText: "Select weekly holiday"),
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      final action = CupertinoActionSheet(
                                        title: Text(
                                          "Weekly Holiday",
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        message: Text(
                                          "Select any option ",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: Text("1"),
                                            onPressed: () {
                                              weeklyHolidayCtr.text = "1";
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("2"),
                                            onPressed: () {
                                              weeklyHolidayCtr.text = "2";
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
}
