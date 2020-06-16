import 'dart:async';

import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/callSearch.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/MyJobProfilePage.dart';
import 'package:flutter_mmhelper/ui/SearchPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'widgets/profile_dateil.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({this.isFromLogin, this.mobileNo, this.querySnapshot});

  QuerySnapshot querySnapshot;
  String mobileNo;
  bool isFromLogin;
}

class _DashboardState extends State<Dashboard> with AfterInitMixin {
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Widget> gridListData = [];
  List<ProfileData> gridSearchListData = [];
  List<ProfileData> listProfileData = List<ProfileData>();
  List<FlContent> listUserData = [];
  SharedPreferences prefs;
  String currentUserId;
  QuerySnapshot querySnapshot;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = new TextEditingController();

  String filter;
  bool isShow = false;
  bool isLoading = true;
  String languageCode;

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });

    fetchLanguage().then((onValue) {
      languageCode = onValue;
    });
  }

  @override
  void didInitState() {
    madeGridList();
    getCurrentUserId();
  }

  onChangeSearchList(List<ProfileData> newGridSearchListData) {
    madeSearchGridList(newGridSearchListData);
  }

  madeSearchGridList(List<ProfileData> newGridSearchListData) async {
    setState(() {
      isLoading = true;
    });
    int i = 1;
    gridListData = [];
    if (newGridSearchListData.length != 0) {
      final database = Provider.of<FirestoreDatabase>(context);
      database.flUserStream().first.then((userDataList) {
        newGridSearchListData.forEach((element) async {
          i++;
          userDataList.forEach((user) {
            if (element.id == user.userId) {
              setState(() {
                gridListData
                    .add(GridCardWidget(element: element, userData: user));
              });
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

//    newGridSearchListData.forEach((element) async {
//      print(element.education);
//      gridListData.add(GridCardWidget(element:element));
//    });
//    setState(() {});
//  }

  /*onSearchChange(String filter) {
    gridListData = [];
    if (gridSearchListData.length == 0) {
      makeSearch(filter: filter, searchListProfileData: listProfileData);
    } else {
      makeSearch(filter: filter, searchListProfileData: gridSearchListData);
    }
  }

  void makeSearch({String filter, List<ProfileData> searchListProfileData}) {
    searchListProfileData.forEach((f) {
      if (f.firstname.toLowerCase().contains(filter.toLowerCase()) ||
          f.selfintroduction.toLowerCase().contains(filter.toLowerCase()))
        gridListData.add(GridCardWidget(f));
    });
    setState(() {});
  }*/

  Future<void> madeGridList() async {
    setState(() {
      isLoading = true;
    });
    print("call grid list");
    int i = 1;
    int userData = 1;
    listProfileData = [];
    gridListData = [];
    listUserData = [];
    final database = Provider.of<FirestoreDatabase>(context);
    Firestore.instance
        .collection(APIPath.userList())
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((element) {
        FlContent flContent = FlContent.fromMap(element.data);
        listUserData.add(flContent);
        userData++;
        if (snapshot.documents.length < userData) {
          database.flContentsStream().first.then((userDataList) {
            listUserData.forEach((user) {
              i++;
              userDataList.forEach((element) {
                if (element.id == user.userId) {
                  print("element.status : ${element.status}");
                  if (element.status == "Approved Manually" ||
                      element.status == "Approved by system" ||
                      element.status == "手動批准" ||
                      element.status == "自動批准") {
                    listProfileData.add(element);
                    setState(() {
                      gridListData.add(
                          GridCardWidget(element: element, userData: user));
                    });
                  }
                }
              });
              if (listUserData.length < i) {
                setState(() {
                  isLoading = false;
                });
              }
            });
          });
        }
      });
      /*if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int profileCount = 0;
        do {
          ProfileData profileData =
              ProfileData.fromMap(snapshot.documents[profileCount].data);
          Firestore.instance
              .collection(APIPath.userList())
              .where("userId", isEqualTo: profileData.id)
              .limit(1)
              .getDocuments()
              .then((snapshot) {
            if (snapshot != null &&
                snapshot.documents != null &&
                snapshot.documents.length > 0) {
              FlContent flContent =
                  FlContent.fromMap(snapshot.documents[0].data);
              listProfileData.add(profileData);
              setState(() {
                gridListData.add(
                    GridCardWidget(element: profileData, userData: flContent));
              });
              print("listProfileData ${listProfileData.length}");
            }
          });
          profileCount++;
        } while (profileCount < snapshot.documents.length);
        setState(() {
          isLoading = false;
        });
      }*/
    });

    /*database.flUserStream().first.then((contents) {
      database.flContentsStream().first.then((userDataList) {
        contents.forEach((user) {
          i++;
          userDataList.forEach((element) {
            if (element.id == user.userId) {
              print(i);
              listProfileData.add(element);
              setState(() {
                gridListData
                    .add(GridCardWidget(element: element, userData: user));
              });
            }
          });
          if (contents.length < i) {
            setState(() {
              isLoading = false;
            });
          }
        });
      });
    });*/
  }

//      contents.forEach((element) async {
//        listProfileData.add(element);
//        gridListData.add(GridCardWidget(element:element));
//      });
//      setState(() {});
//    });
//  }

  Widget GridCardWidget({ProfileData element, FlContent userData}) {
    print(element.workskill);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDateil(
            profileData: element,
            languageCode: languageCode,
            userData: userData,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: SizeConfig.screenWidth / 2 - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                element.userName ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                            Text(
                              element.birthday != null
                                  ? " (${(DateTime.now().difference(element.birthday).inDays / 365).round()})"
                                  : "(0)",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            element.contract,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            element.current == "Hong Kong" ||
                                    element.current == "香港"
                                ? " (HK)"
                                : "",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          element.workskill.contains("Care Disabled") ||
                                  element.workskill.contains("照顧殘疾")
                              ? skillIconWidget(link: "assets/disabled.png")
                              : SizedBox(),
                          element.workskill.contains("Care Elderly") ||
                                  element.workskill.contains("照顧老人")
                              ? skillIconWidget(link: "assets/older2.png")
                              : SizedBox(),
                          element.workskill.contains("Care Todlers") ||
                                  element.workskill.contains("護理幼兒")
                              ? skillIconWidget(link: "assets/baby.png")
                              : SizedBox(),
                          element.workskill.contains("Care Kids") ||
                                  element.workskill.contains("照顧孩子")
                              ? skillIconWidget(link: "assets/kids.png")
                              : SizedBox(),
                          element.workskill.contains("Care Pets") ||
                                  element.workskill.contains("護理寵物")
                              ? skillIconWidget(link: "assets/pat.png")
                              : SizedBox(),
                          element.workskill.contains("Chinese Food") ||
                                  element.workskill.contains("中國菜")
                              ? skillIconWidget(link: "assets/cook.png")
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: element.nationality == "Philippines" ||
                        element.nationality == "菲律賓"
                    ? Text(
                        "🇵🇭",
                        style: TextStyle(fontSize: 30),
                      )
                    : element.nationality == "Indonesia" ||
                            element.nationality == "印度尼西亞"
                        ? Text(
                            "🇮🇩",
                            style: TextStyle(fontSize: 30),
                          )
                        : SizedBox(),
                right: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget skillIconWidget({String link}) {
    return Row(
      children: <Widget>[
        Image.asset(
          link,
          width: 20,
          height: 20,
        ),
        SizedBox(
          width: 5,
        )
      ],
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

  /*Future<String> getImageUrl(DocumentReference imageReference) {
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
  }*/

  List<String> eduStringList = [];
  List<String> religionStringList = [];
  List<String> maritalStringList = [];
  List<String> childrenStringList = [];
  List<String> jobTypeStringList = [];
  List<String> jobCapStringList = [];
  List<String> contractStringList = [];
  List<String> nationalityStringList = [];
  List<String> workingSkillStringList = [];
  List<String> languageStringList = [];
  List<String> searchText = [];

  onChangeFunction(bool changeValue) {
    print("onChangeFunction $changeValue");
    if (changeValue != null && changeValue) {
      madeGridList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final callSearch = Provider.of<CallSearch>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Home')),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                if (searchText.length == 0) searchText.add('');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPage(
                    onChanged: onChangeSearchList,
                    listProfileData: listProfileData,
                    searchText: searchText,
                    eduStringList: eduStringList,
                    religionStringList: religionStringList,
                    maritalStringList: maritalStringList,
                    childrenStringList: childrenStringList,
                    jobTypeStringList: jobTypeStringList,
                    jobCapStringList: jobCapStringList,
                    contractStringList: contractStringList,
                    nationalityStringList: nationalityStringList,
                    workingSkillStringList: workingSkillStringList,
                    languageStringList: languageStringList,
                  );
                }));
              }),
        ],
      ),
      key: scaffoldKey,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /*FloatingActionButton(
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
            ),*/
          widget.querySnapshot.documents[0]["role"] != "Employer"
              ? FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    if (querySnapshot != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyJobProfilePage(
                          userId: querySnapshot.documents[0]["userId"],
                          loginUserData: querySnapshot,
                          valueChanged: onChangeFunction,
                        );
                      }));
                    } else {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_wait')),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : SizedBox()
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
      body: isLoading == false
          ? Column(
              children: <Widget>[
                /*isShow?Padding(
                padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                child: TextField(
                  onChanged: onSearchChange,
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        gridSearchListData = [];
                        madeGridList();
                        searchController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    hintText: "Search",
                  ),
                  controller: searchController,
                )):SizedBox(),*/
                gridListData.length != 0 && isLoading == false
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: madeGridList,
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio:
                                        SizeConfig.safeBlockHorizontal / 4.7,
                                    crossAxisCount: 2),
                            children: gridListData,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Text(AppLocalizations.of(context)
                              .translate('No_data_found')),
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
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
                            snapshot.data.documents[index]["lastname"] +
                            "(${DateTime.now().subtract(snapshot.data.documents[index]["birthday"])})",
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
