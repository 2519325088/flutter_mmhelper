import 'dart:async';

import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/interface/firebase_phone_util.dart';
import 'package:flutter_mmhelper/interface/search_listenter.dart';
import 'package:flutter_mmhelper/services/callSearch.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/MyJobProfilePage.dart';
import 'package:flutter_mmhelper/ui/SearchPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/profile_dateil.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({this.isFromLogin, this.mobileNo, this.querySnapshot});

  QuerySnapshot querySnapshot;
  String mobileNo;
  bool isFromLogin;
}

class _DashboardState extends State<Dashboard>
    with AfterInitMixin
    implements SearchClickListener {
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Widget> gridListData = [];
  List<ProfileData> gridSearchListData = [];
  List<ProfileData> listProfileData = [];
  SharedPreferences prefs;
  String currentUserId;
  QuerySnapshot querySnapshot;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchClickUtil searchClickUtil;

  @override
  void initState() {
    super.initState();
    searchClickUtil = SearchClickUtil();
    searchClickUtil.setScreenListener(this);
  }

  @override
  onClickSearch() {
    print("Dashboard onClickSearch");
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(
        onChanged: onChangeSearchList,
        listProfileData: listProfileData,
      );
    }));
    return null;
  }

  @override
  void didInitState() {
    madeGridList();
    getCurrentUserId();
  }

  onChangeSearchList(List<ProfileData> newGridSearchListData) {
    print("this is length ${newGridSearchListData.length}");
    madeSearchGridList(newGridSearchListData);
  }

  madeSearchGridList(List<ProfileData> newGridSearchListData) async {
    gridListData = [];
    newGridSearchListData.forEach((element) async {
      print(element.education);
      gridListData.add(GridCardWidget(element));
    });
    setState(() {});
  }

  madeGridList() async {
    listProfileData = [];
    gridListData = [];
    gridSearchListData = [];
    final database = Provider.of<FirestoreDatabase>(context);
    database.flContentsStream().first.then((contents) {
      contents.forEach((element) async {
        listProfileData.add(element);
        gridSearchListData.add(element);
        gridListData.add(GridCardWidget(element));
      });
      setState(() {});
    });
  }

  Widget GridCardWidget(ProfileData element) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDateil(
            profileData: element,
          );
        }));
      },
      child: Card(
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    child: Image.asset(
                      "assets/placeholder.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  imageUrl: element.primaryImage ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment(0, 1.2),
                        end: Alignment(0, 0))),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        element.firstname + " " + element.lastname ??
                            "No username",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        element.nationality ?? "No nationality",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        element.gender ?? "No gender",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCurrentUserId() async {

      querySnapshot = await Firestore.instance
          .collection("mb_content")
          .where("phone", isEqualTo: widget.mobileNo)
          .getDocuments();
      currentUserId = querySnapshot.documents[0].data["userId"];
      prefs = await SharedPreferences.getInstance();
      prefs.setString("loginUid", querySnapshot.documents[0].data["userId"]);
      print("this is i got:$currentUserId");

  }

  Future<String> getImageUrl(DocumentReference imageReference) {
    var completer = Completer<String>();
    imageReference.get().then((onVlaue) {
      FirebaseStorage.instance
          .ref()
          .child("/flamelink/media/${onVlaue.data["file"]}")
          .getDownloadURL()
          .then((onValue) {
        completer.complete(onValue);
      });
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final callSearch = Provider.of<CallSearch>(context);
    SizeConfig().init(context);
    return Scaffold(
        key: scaffoldKey,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPage(
                    onChanged: onChangeSearchList,
                    listProfileData: listProfileData,
                  );
                }));
              },
              child: Icon(Icons.search),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                if (querySnapshot != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyJobProfilePage(
                      userId: querySnapshot.documents[0]["userId"],
                      loginUserData: querySnapshot,
                    );
                  }));
                } else {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Please wait..."),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
        /*appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.video_call),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IndexPage();
                  }));
                }),
            IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatUserPage(
                      currentUserId: currentUserId,
                    );
                  }));
                }),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async{
                  database.lastUserId = null;
                  _firebaseAuth.signOut();
                  facebookLogin.logOut();
                  prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }), (Route<dynamic> route) => false);
                }),
          ],
        ),*/
        body: gridListData.length != 0
            ? GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: SizeConfig.safeBlockHorizontal / 4.7,
                    crossAxisCount: 2),
                children: gridListData,
              )
            : Center(
                child: Text("No data found"),
              )
        /*StreamBuilder(
          stream: Firestore.instance
              .collection('mb_profile')
              .where("education", whereIn: ["Elementary"])
              .where("religion", whereIn: ["Moslem"])
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: SizeConfig.safeBlockHorizontal / 4.9,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return buildCard(context, snapshot, index);
                    },
                    itemCount: snapshot.data.documents.length,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        )*/
        );
  }

  Widget buildCard(BuildContext context, AsyncSnapshot snapshot, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDateil(
              /*proSnapshot: snapshot.data.documents[index],*/
              );
        }));
      },
      child: Card(
        elevation: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    child: Image.asset(
                      "assets/placeholder.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  imageUrl:
                      snapshot.data.documents[index]["primaryimage"] ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment(0, 1.2),
                        end: Alignment(0, 0))),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data.documents[index]["firstname"] +
                                " " +
                                snapshot.data.documents[index]["lastname"] ??
                            "No username",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        snapshot.data.documents[index]["nationaity"] ??
                            "No nationality",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        snapshot.data.documents[index]["gender"] ?? "No gender",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
