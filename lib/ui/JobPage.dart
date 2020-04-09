import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/PostJobPage.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
  final String currentUserId;

  JobPage({this.currentUserId});
}

class _JobPageState extends State<JobPage> with AfterInitMixin {
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
      floatingActionButton: FloatingActionButton(
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
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: Firestore.instance
                      .collection('mb_content')
                      .document(snapshot.data.documents[index]["user_id"])
                      .snapshots(),
                  builder: (context, snapshot2) {
                    return jobCard(
                        userName: snapshot2.data["firstname"],
                        shortDes: snapshot.data.documents[index]
                            ["job_short_description"]);
                  });
            },
            itemCount: snapshot.data.documents.length,
          );
        },
      ),
    );
  }

  Widget jobCard({
    String shortDes,
    String userName,
  }) {
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
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "View more >",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
