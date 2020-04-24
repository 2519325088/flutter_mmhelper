import 'dart:async';

import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/ChatUserPage.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';
import 'widgets/profile_dateil.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({this.isFromLogin, this.mobileNo});

  String mobileNo;
  bool isFromLogin;
}

class _DashboardState extends State<Dashboard> with AfterInitMixin {
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Widget> gridListData = [];
  SharedPreferences prefs;
  String currentUserId;
  QuerySnapshot querySnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    madeGridList();
    getCurrentUserId();
  }

  getCurrentUserId() async {
    if (widget.isFromLogin) {
      querySnapshot = await Firestore.instance
          .collection("mb_content")
          .where("phone", isEqualTo: widget.mobileNo)
          .getDocuments();
      currentUserId = querySnapshot.documents[0].data["userId"];
      prefs = await SharedPreferences.getInstance();
      prefs.setString("loginUid", querySnapshot.documents[0].data["userId"]);
      print("this is i got:$currentUserId");
    } else {
      prefs = await SharedPreferences.getInstance();
      currentUserId = prefs.getString('loginUid');
      print("currentUser:${currentUserId}");
    }
  }

  madeGridList() async {
    final database = Provider.of<FirestoreDatabase>(context);
    database.flContentsStream().first.then((contents) {
      contents.forEach((element) async {
        gridListData.add(Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                child: Container(
                  height: 150,
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
                    imageUrl: element.imagelist[0] ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        element.firstname ?? "No username",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        element.nationaity ?? "No nationality",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(element.gender ?? "No gender"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      });
    });
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
    final database = Provider.of<FirestoreDatabase>(context);
    SizeConfig().init(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MamaProfile();
            }));
          },
          child: Icon(Icons.add),
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
        body:
            /*GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: SizeConfig.safeBlockHorizontal / 4.7,
                    crossAxisCount: 2),
                children: gridListData,
              )*/
            StreamBuilder(
          stream: Firestore.instance.collection('mb_profile').snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: SizeConfig.safeBlockHorizontal / 4.7,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfileDateil(
                              proSnapshot: snapshot.data.documents[index],
                            );
                          }));
                        },
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    topLeft: Radius.circular(5)),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                      child: Image.asset(
                                        "assets/placeholder.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    imageUrl: snapshot.data.documents[index]
                                            ["primaryimage"] ??
                                        "",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.documents[index]
                                                    ["firstname"] +
                                                " " +
                                                snapshot.data.documents[index]
                                                    ["lastname"] ??
                                            "No username",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        snapshot.data.documents[index]
                                                ["nationaity"] ??
                                            "No nationality",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(snapshot.data.documents[index]
                                              ["gender"] ??
                                          "No gender"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.documents.length,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ));
  }
}
