import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  @override
  _JobDetailPageState createState() => _JobDetailPageState();
  DocumentSnapshot jobSnapshot;
  DocumentSnapshot userSnapshot;

  JobDetailPage({this.jobSnapshot, this.userSnapshot});
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableInCtr.text = DateFormat.yMMMMEEEEd()
        .format(DateTime.tryParse(widget.jobSnapshot['available']))
        .toString();
    jobTypeCtr.text = widget.jobSnapshot['job_type'];
    contractTypeCtr.text = widget.jobSnapshot['contract_type'];
    workingLocationDesCtr.text = widget.jobSnapshot['working_location'];
    salaryCtr.text =
        "${widget.jobSnapshot['salary']} ${widget.jobSnapshot['currencyType']}";
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
                                  child: Text(widget.userSnapshot['firstname']
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
                                      widget.userSnapshot['firstname'] ?? "",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "1h ago",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text(
                            widget.jobSnapshot['job_short_description'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          gradient: LinearGradient(
                              colors: [Colors.pink, Colors.red])),
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    )
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
                          title: "Job Type",
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
