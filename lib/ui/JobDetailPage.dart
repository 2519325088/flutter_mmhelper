import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/Models/JobDetailDataModel.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/ChatPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'widgets/CustomPopup.dart';

class JobDetailPage extends StatefulWidget {
  @override
  _JobDetailPageState createState() => _JobDetailPageState();
  JobDetailData jobDetailData;
  FlContent userData;
  String currentUser;
  bool isAvailable;
  QuerySnapshot userSnapshot;

  JobDetailPage(
      {this.jobDetailData,
      this.userData,
      this.currentUser,
      this.isAvailable,
      this.userSnapshot});
}

class _JobDetailPageState extends State<JobDetailPage> {
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
  bool isLoginUser = true;
  bool isShowAlert = true;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoneUserId().then((value) {
      print(widget.userData.userId);
      print(value);
      if (widget.userData.userId!= value) {
        setState(() {
          isLoginUser = false;
        });
      }
    });
    availableInCtr.text = DateFormat.yMMMMEEEEd()
        .format(widget.jobDetailData.available)
        .toString();
    jobTypeCtr.text = widget.jobDetailData.jobType;
    jobShortDesCtr.text = widget.jobDetailData.jobShortDescription;
    contractTypeCtr.text = widget.jobDetailData.contractType;
    workingLocationDesCtr.text = widget.jobDetailData.workingLocation;
    salaryCtr.text =
        "${widget.jobDetailData.salary} ${widget.jobDetailData.currencyType}";
    unitSizeCtr.text = widget.jobDetailData.unitSize;
    accommodationCtr.text= widget.jobDetailData.accommodation;
    weeklyHolidayCtr.text = widget.jobDetailData.weeklyHoliday;
    skillCtr.text = widget.jobDetailData.skillRequirement ;
    moreJobDesCtr.text = widget.jobDetailData.moreDescription;
  }

  Future<String> getPhoneUserId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("PhoneUserId");
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
    TextStyle titleText = TextStyle(
        fontSize: 18,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.bold);
    TextStyle dataText = TextStyle(fontSize: 18);
    Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
    Color gradientEnd = Color(0xffe7d981);
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Post Details"),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isShowAlert
                  ? Stack(
                      children: [
                        Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Users shall not request any pre-paid money for hiring. Stay alert of online spam.",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isShowAlert = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    )
                  : SizedBox(),
              Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12, right: 8, top: 8),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  child: Text(widget.userData.firstname
                                      .substring(0, 1)
                                      .toUpperCase()),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.userData.firstname ?? "",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      timeago.format(widget.jobDetailData.createTime??DateTime.now()),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text(
                            widget.jobDetailData.jobShortDescription,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    widget.userData.userId != widget.currentUser
                        ? GestureDetector(
                            onTap: () async {
                              if (widget.isAvailable) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatPage(
                                      peerId: widget.userData.userId,
                                      peerAvatar:
                                          widget.userData.profileImageUrl,
                                      peerName:
                                          "${widget.userData.firstname ?? ""} ${widget.userData.lastname ?? ""}");
                                }));
                              } else {
                                if (widget.userSnapshot.documents[0]["role"] !=
                                    "Employer") {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatPage(
                                        peerId: widget.userData.userId,
                                        peerAvatar:
                                            widget.userData.profileImageUrl,
                                        peerName:
                                            "${widget.userData.firstname ?? ""} ${widget.userData.lastname ?? ""}");
                                  }));
                                } else {
                                  await showDialog<String>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return CustomPopup(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          title: "Want to contact the helper?",
                                          message:
                                              "Before contacting the helper, you need to create and publish a finding FOREIGN helper job post!",
                                        );
                                      });
                                }
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  gradient: LinearGradient(
                                      colors: [gradientStart, gradientEnd])),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.chat,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Request to Connect",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Job Description",
                          filedCtr: jobShortDesCtr,
                          icons: Icons.description,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Preferred Contract Status",
                          filedCtr: contractTypeCtr,
                          icons: Icons.perm_contact_calendar,
                          maxLine: 3),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Job Hiring Location",
                          filedCtr: workingLocationDesCtr,
                          icons: Icons.location_on,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Job Capacity",
                          filedCtr: jobTypeCtr,
                          icons: Icons.perm_contact_calendar,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Job Salary",
                          filedCtr: salaryCtr,
                          icons: Icons.monetization_on,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Employment Start Date",
                          filedCtr: availableInCtr,
                          icons: Icons.date_range,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Unit Size",
                          filedCtr: unitSizeCtr,
                          icons: Icons.home,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Accommodation",
                          filedCtr: accommodationCtr,
                          icons: Icons.dashboard,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Weekly Holoday",
                          filedCtr: weeklyHolidayCtr,
                          icons: Icons.dashboard,
                          maxLine: 1),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "Working Skill",
                          filedCtr: skillCtr,
                          icons: Icons.library_books,
                          maxLine: 3),
                      jobDataField(
                          titleText: titleText,
                          dataText: dataText,
                          title: "More Job Description",
                          filedCtr: moreJobDesCtr,
                          icons: Icons.description,
                          maxLine: 3),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget jobDataField(
      {String title,
      TextStyle titleText,
      TextStyle dataText,
      TextEditingController filedCtr,
      IconData icons,
      int maxLine}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icons,
            color: Colors.black54,
            size: 25,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$title:",
                  style: titleText,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: TextFormField(
                    maxLines: maxLine,
                    style: dataText,
                    controller: filedCtr,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
