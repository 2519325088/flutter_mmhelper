import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/MyJobProfilePage.dart';
import 'package:flutter_mmhelper/ui/MyProfilePage.dart';
import 'package:provider/provider.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
  QuerySnapshot querySnapshot;

  MePage({this.querySnapshot});
}

class _MePageState extends State<MePage> {
  BorderSide borderSide = BorderSide(color: Colors.black.withOpacity(0.1));
  String userType;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.querySnapshot.documents[0]["type"]
        .toString()
        .contains("Employer")) {
      userType = "1";
    } else if (widget.querySnapshot.documents[0]["type"]
        .toString()
        .contains("Foreign Helper")) {
      userType = "2";
    } else if (widget.querySnapshot.documents[0]["type"]
        .toString()
        .contains("Local Auntie")) {
      userType = "3";
    }
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyProfilePage(
                        myProfileDocumentSnapshot:
                            widget.querySnapshot.documents[0],
                      );
                    }));
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                      radius: 40,
                                      backgroundImage: AssetImage(
                                        "assets/placeholder.jpg",
                                      )),
                              imageUrl: widget.querySnapshot.documents[0]
                                      ["profileImageUrl"] ??
                                  "",
                              fit: BoxFit.cover,
                              imageBuilder: (BuildContext context, image) {
                                return CircleAvatar(
                                  radius: 40,
                                  backgroundImage: image,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${widget.querySnapshot.documents[0]["username"] ?? ""}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.border_color,
                                  size: 15,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    onTap: () {
                      if (userType == "1") {
                      } else if (userType == "2") {

                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return MyJobProfilePage(
                                userId: widget.querySnapshot.documents[0]["userId"],
                              );
                            }));
                      }
                    },
                    title: Text(userType == "1"
                        ? "My Job Posts"
                        : userType == "2" ? "My Profiles" : "My Profile"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: ListTile(
                    title: Text("Job offers"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    title: Text("Shortlisted Applicants"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    title: Text("Pricing"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    title: Text("Referral Program"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    title: Text("Vouchers"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    title: Text("FAQ / Tutorials"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
