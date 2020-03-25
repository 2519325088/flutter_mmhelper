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
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({this.isFromLogin});

  bool isFromLogin;
}

class _DashboardState extends State<Dashboard> with AfterInitMixin {
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Widget> gridListData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didInitState() {
    madeGridList();
  }

  madeGridList() async {
    final database = Provider.of<FirestoreDatabase>(context);
    database.flContentsStream().first.then((contents) {
      int i = 0;
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
                    imageUrl: await getImageUrl(
                            element.imageDeck[0].image[0] as DocumentReference)
                        .then((imagePath) {
                      i += 1;
                      print(i);
                      return imagePath;
                    }),
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
                        element.lastname ?? "No lastname",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        element.firstname ?? "No firstname",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        element.username ?? "No username",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        element.nationality ?? "No nationality",
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
        if (contents.length == i) {
          setState(() {});
        }
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
        appBar: AppBar(
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
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  database.lastUserId = null;
                  _firebaseAuth.signOut();
                  facebookLogin.logOut();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }), (Route<dynamic> route) => false);
                })
          ],
        ),
        body: gridListData.length != 0
            ? GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: SizeConfig.safeBlockHorizontal / 4.7,
                    crossAxisCount: 2),
                children: gridListData,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
