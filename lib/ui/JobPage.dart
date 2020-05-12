import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/Models/JobDetailDataModel.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/ui/JobDetailPage.dart';
import 'package:flutter_mmhelper/ui/JobSearchPage.dart';
import 'package:flutter_mmhelper/ui/PostJobPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobPage extends StatefulWidget {
  @override
  _JobPageState createState() => _JobPageState();
  final String currentUserId;

  JobPage({this.currentUserId});
}

class _JobPageState extends State<JobPage> with AfterInitMixin {
  List<Widget> gridListData = [];
  List<JobDetailData> listJobData = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 /*   SharedPreferences.getInstance().then((prefs) {
      print(prefs.getString("PhoneUserId"));
      var contract = Firestore.instance
          .collection('mb_contract')
          .where('created_by', isEqualTo: prefs.getString("PhoneUserId"))
          .getDocuments()
          .then((snapshot) {
        snapshot.documents.forEach((f) => print('snapshot :${f.data}}'));
      });
    });*/
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    madeGridList();
  }

  onChangeSearchList(List<JobDetailData> newGridSearchListData) {
    print("this is length ${newGridSearchListData.length}");
    madeSearchGridList(newGridSearchListData);
  }

  madeSearchGridList(List<JobDetailData> newGridSearchListData) async {
    setState(() {
      isLoading = true;
    });
    int i = 1;
    gridListData = [];
    if (newGridSearchListData.length != 0) {
      final database = Provider.of<FirestoreDatabase>(context);
      database.flUserStream().first.then((userDataList) {
        newGridSearchListData.forEach((jobElement) async {
          i++;
          userDataList.forEach((user) {
            if (jobElement.userId == user.userId) {
              gridListData.add(jobCard(
                  userData: user,
                  jobDetailData: jobElement,
                  userName: user.username));
            }
          });
          if (newGridSearchListData.length <= i) {
            setState(() {
              isLoading = false;
            });
          }
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  madeGridList() async {
    int i = 1;
    listJobData = [];
    gridListData = [];
    final database = Provider.of<FirestoreDatabase>(context);
    database.flJobStream().first.then((contents) {
      database.flUserStream().first.then((userDataList) {
        contents.forEach((jobElement) async {
          i++;
          userDataList.forEach((user) {
            if (jobElement.userId == user.userId) {
              listJobData.add(jobElement);
              gridListData.add(jobCard(
                  userData: user,
                  jobDetailData: jobElement,
                  userName: user.username));
            }
          });
          if (contents.length < i) {
            setState(() {
              isLoading = false;
            });
          }
        });
        print(listJobData.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('Job')),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return JobSearchPage(
                      onChanged: onChangeSearchList,
                      listJobData: listJobData,
                    );
                  }));
                }),
          ],
        ),
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
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: isLoading == false
            ? gridListData.length != 0
                ? ListView(
                    children: gridListData,
                  )
                : Center(
                    child: Text(
                        AppLocalizations.of(context).translate('No_any_job')),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget jobCard(
      {JobDetailData jobDetailData,
      FlContent userData,
      String shortDes,
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
              jobDetailData.jobShortDescription ?? "",
              style: TextStyle(fontSize: 16),
            ),
            Divider(
              color: Colors.black.withOpacity(0.6),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return JobDetailPage(
                    jobDetailData: jobDetailData,
                    userData: userData,
                  );
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('View_More'),
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
