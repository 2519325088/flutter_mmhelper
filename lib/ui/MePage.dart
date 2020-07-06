import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/AppLanguage.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:flutter_mmhelper/ui/MyJobListPage.dart';
import 'package:flutter_mmhelper/ui/MyJobProfilePage.dart';
import 'package:flutter_mmhelper/ui/MyProfilePage.dart';
import 'package:flutter_mmhelper/ui/ApplicationDetails.dart';
import 'package:flutter_mmhelper/ui/SoundRecording.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mmhelper/ui/ShortlistedApplicats.dart';

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
  QuerySnapshot querySnapshot;
  String currentUserId;

  MePage({this.querySnapshot, this.currentUserId});
}

class _MePageState extends State<MePage> {
  BorderSide borderSide = BorderSide(color: Colors.black.withOpacity(0.1));
  String userType;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.querySnapshot != null) {
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Me"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              final database = Provider.of<FirestoreDatabase>(context);
              database.lastUserId = null;
              prefs = await SharedPreferences.getInstance();
              prefs.remove("PhoneUserId");
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      key: scaffoldKey,
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return MyJobListPage(
                                querySnapshot: widget.querySnapshot,
                                currentUserId: widget.currentUserId,
                              );
                            }));
                      } else {
                        if (widget.querySnapshot != null) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MyJobProfilePage(
                              userId: widget.querySnapshot.documents[0]
                                  ["userId"],
                              loginUserData: widget.querySnapshot,
                            );
                          }));
                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Please wait..."),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      }
                    },
                    title:
                        Text(userType == "1" ? "My Job Posts" : "My Profile"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                /*Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: ListTile(
                    title: Text("Job offers"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),*/
                /*Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: ListTile(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      appLanguage.changeLanguage(Locale("en"));
                                      Navigator.pop(context);
                                    },
                                    title: Text("English"),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      appLanguage.changeLanguage(Locale("zh"));
                                      Navigator.pop(context);
                                    },
                                    title: Text("中文"),
                                  ),
                                ]);
                          });
                    },
                    title: Text(
                        "${AppLocalizations.of(context).translate('languageTitle')}: ${AppLocalizations.of(context).translate('language')}"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),*/
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
//                            return SoundRecording();
                            return Shortlisted(
                              isFromLogin: true,
                              mobileNo: widget.querySnapshot.documents[0]
                              ["phone"],
                              querySnapshot: widget.querySnapshot,
                            );
                          }));
                    },
                    title: Text("Shortlisted Applicants"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                /*Container(
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
                ),*/
                /*Container(
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
                ),*/
                /*Container(
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
                ),*/
                /*Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    onTap: () {},
                    title: Text("FAQ / Tutorials"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),*/
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide.none,
                          left: borderSide,
                          right: borderSide,
                          bottom: borderSide)),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
//                            return SoundRecording();
                        return ApplicationDetails(
                          userId: widget.querySnapshot.documents[0]["userId"],
                        );
                      }));
                    },
                    title: Text("Application Details"),
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
