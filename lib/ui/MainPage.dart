import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/ui/ChatUserPage.dart';
import 'package:flutter_mmhelper/ui/JobPage.dart';
import 'package:flutter_mmhelper/ui/MePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';
import 'LoginScreen.dart';
import 'index.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();

  MainPage({this.isFromLogin, this.mobileNo});

  String mobileNo;
  bool isFromLogin;
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  String titleText = "Home";
  final _firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  List<Widget> gridListData = [];
  SharedPreferences prefs;
  String currentUserId;
  QuerySnapshot querySnapshot;
  bool isShow = true;
  bool isMeLoading = true;

  bottomClick(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        titleText = "Home";
        setState(() {
          isShow = true;
        });
      } else if (index == 1) {
        setState(() {
          isShow = true;
        });
        titleText = "Job";
      } else if (index == 2) {
        titleText = "Chat";
        setState(() {
          isShow = false;
        });
      } else {
        setState(() {
          isShow = true;
        });
        titleText = "Me";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserId();
  }

  getCurrentUserId() async {
    if (widget.isFromLogin) {
      isMeLoading = true;
      querySnapshot = await Firestore.instance
          .collection("mb_content")
          .where("phone", isEqualTo: widget.mobileNo)
          .getDocuments();
      currentUserId = querySnapshot.documents[0].data["userId"];
      prefs = await SharedPreferences.getInstance();
      prefs.setString("loginUid", querySnapshot.documents[0].data["userId"]);
      isMeLoading = false;
    } else {
      prefs = await SharedPreferences.getInstance();
      currentUserId = prefs.getString('loginUid');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      Dashboard(
        mobileNo: widget.mobileNo,
        isFromLogin: widget.isFromLogin,
        querySnapshot: querySnapshot,
      ),
      JobPage(
        currentUserId: currentUserId,
      ),
      ChatUserPage(
        mobileNo: widget.mobileNo,
        currentUserId: currentUserId,
      ),
      MePage(
        querySnapshot: querySnapshot,
      ),
    ];
    final database = Provider.of<FirestoreDatabase>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: <Widget>[
          DrawerHeader(child: null),
          ListTile(
            onTap: () async {
              database.lastUserId = null;
              _firebaseAuth.signOut();
              facebookLogin.logOut();
              prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), (Route<dynamic> route) => false);
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          )
        ]),
      ),
      appBar: AppBar(
        title: Text(titleText),
        actions: <Widget>[
          isShow
              ? IconButton(
                  icon: Icon(Icons.video_call),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return IndexPage();
                    }));
                  })
              : SizedBox(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), title: Text("Job")),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Chat")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("Me"))
        ],
        onTap: (i) {
          bottomClick(i);
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.pink,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
      body: widgetOptions.elementAt(selectedIndex),
      /*body: IndexedStack(
        index: selectedIndex,
        children: widgetOptions,
      ),*/
    );
  }
}
