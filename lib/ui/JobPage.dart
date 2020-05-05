import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/JobDetailPage.dart';
import 'package:flutter_mmhelper/ui/PostJobPage.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
  final String currentUserId;

  JobPage({this.currentUserId});
}

class _JobPageState extends State<JobPage> with AfterInitMixin {
  String searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job"),),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PostJobPage(
              currentUserId: widget.currentUserId,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('fl_job_post')
            .orderBy("id", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('mb_content')
                            .document(snapshot.data.documents[index]["user_id"])
                            .snapshots(),
                        builder: (context, snapshot2) {
                          return snapshot2.hasData
                              ? jobCard(
                                  userName: snapshot2.data["firstname"] ?? "",
                                  shortDes: snapshot.data.documents[index]
                                          ["job_short_description"] ??
                                      "",
                                  jobSnapshot: snapshot.data.documents[index],
                                  userSnapshot: snapshot2.data)
                              : SizedBox();
                        });
                  },
                  itemCount: snapshot.data.documents.length,
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Widget jobCard(
      {String shortDes,
      String userName,
      DocumentSnapshot jobSnapshot,
      DocumentSnapshot userSnapshot}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 8, top: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Text(userName.substring(0, 1).toUpperCase()),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName ?? "",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
              shortDes,
              style: TextStyle(fontSize: 16),
            ),
            Divider(
              color: Colors.black.withOpacity(0.6),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return JobDetailPage(
                    jobSnapshot: jobSnapshot,
                    userSnapshot: userSnapshot,
                  );
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "View more",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
