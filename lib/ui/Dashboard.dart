import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('fl_content')
            .document(database.lastUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: (context, url) =>
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          radius: 50,
                          child: Center(
                              child:
                              CircularProgressIndicator()),
                        ),
                    errorWidget: (context, url,
                        error) =>
                        CircleAvatar(
                            radius: 50,
                            child: Center(
                                child: Icon(Icons
                                    .error))),
                    imageUrl: snapshot.data["profileImageUrl"],
                    imageBuilder: (context,image){
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: image,
                      );
                    },
                  ),
                  Text("Name:${snapshot.data["name"]}"),
                  Text("Nationality:${snapshot.data["nationality"]}"),
                  Text("Religion:${snapshot.data["religion"]}"),
                  Text("Gender:${snapshot.data["gender"]}"),
                  FlatButton(
                    onPressed: () {
                      database.lastUserId = null;
                      _firebaseAuth.signOut();
                      facebookLogin.logOut();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }), (Route<dynamic> route) => false);
                    },
                    child: Text("Logout",style: TextStyle(color: Colors.white),),
                    color: Colors.pink,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
