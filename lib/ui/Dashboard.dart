import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({this.isFromLogin});

  bool isFromLogin;
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
        actions: <Widget>[
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
      body: StreamBuilder<List<FlContent>>(
        stream: database.flContentsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            final candidate = snapshot.data;
            final children = candidate
                .map((candidate) => Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5)),
                            child: Container(
                              height: 120,
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
                                imageUrl: candidate.profileImageUrl ?? "",
                                fit: BoxFit.fill,
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
                                    candidate.name ?? "No name",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    candidate.nationality ?? "No nationality",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(candidate.gender ?? "No gender"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList();
            return GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.89, crossAxisCount: 2),
              children: children,
            );
          }
        },
      ),
    );
  }
}
