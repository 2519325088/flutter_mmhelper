import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/Models/JobDetailDataModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/ui/JobDetailPage.dart';
import 'package:flutter_mmhelper/ui/JobSearchPage.dart';
import 'package:flutter_mmhelper/ui/PostJobPage.dart';
import 'package:flutter_mmhelper/ui/widgets/CustomPopup.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyJobListPage extends StatefulWidget {
  @override
  _MyJobListPageState createState() => _MyJobListPageState();
  final String currentUserId;
  QuerySnapshot querySnapshot;

  MyJobListPage({this.currentUserId, this.querySnapshot});
}

class _MyJobListPageState extends State<MyJobListPage> with AfterInitMixin {
  List<Widget> gridListData = [];
  List<JobDetailData> listJobData = [];
  bool isLoading = true;
  bool isAvailable = false;

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
                  userName: user.username,
                  currentUser: widget.currentUserId));
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
    listJobData = [];
    gridListData = [];
    Firestore.instance
        .collection(APIPath.userList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int profileCount = 0;
        do {
          FlContent userSignUp =
              FlContent.fromMap(snapshot.documents[profileCount].data);
          await Firestore.instance
              .collection(APIPath.jobList())
              .where("user_id", isEqualTo: userSignUp.userId)
              .limit(1)
              .getDocuments()
              .then((snapshotProfile) {
            if (snapshotProfile != null &&
                snapshotProfile.documents != null &&
                snapshotProfile.documents.length > 0) {
              JobDetailData jobElement =
                  JobDetailData.fromMap(snapshotProfile.documents[0].data);
              if (jobElement.userId == widget.currentUserId) {
                listJobData.add(jobElement);
                gridListData.add(jobCard(
                  userData: userSignUp,
                  jobDetailData: jobElement,
                  userName: userSignUp.username,
                  currentUser: widget.currentUserId,
                ));
              }
            }
          });
          profileCount++;
        } while (profileCount < snapshot.documents.length);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  List<String> contractStringList = [];
  List<String> jobTypeStringList = [];
  List<String> accommodationStringList = [];
  List<String> searchText = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('myJobPosts'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                if (searchText.length == 0) searchText.add('');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return JobSearchPage(
                    onChanged: onChangeSearchList,
                    listJobData: listJobData,
                    searchText: searchText,
                    contractStringList: contractStringList,
                    jobTypeStringList: jobTypeStringList,
                    accommodationStringList: accommodationStringList,
                  );
                }));
              }),
        ],
      ),
      floatingActionButton: widget.querySnapshot.documents[0]["role"] ==
              "Employer"
          ? FloatingActionButton(
              heroTag: null,
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PostJobPage(
                    currentUserId: widget.currentUserId,
                  );
                })).then((value) => madeGridList());
              },
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : SizedBox(),
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
            ),
    );
  }

  Widget jobCard(
      {JobDetailData jobDetailData,
      FlContent userData,
      String shortDes,
      String userName,
      String currentUser,
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
                    child: Text(userName != ""
                        ? userName.substring(0, 1).toUpperCase()
                        : "U"),
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
                        timeago
                            .format(jobDetailData.createTime ?? DateTime.now()),
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
                    currentUser: currentUser,
                    isAvailable: isAvailable,
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
