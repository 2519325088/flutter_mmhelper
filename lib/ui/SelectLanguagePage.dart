import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/AppLanguage.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguagePage extends StatefulWidget {
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  bool isSelectLanguage = false;
  bool isLoading = false;
  bool english = false;
  bool china = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLocale();
  }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginScreen();
      }), (Route<dynamic> route) => false);
    } else {
      setState(() {
        isSelectLanguage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return isSelectLanguage
        ? Scaffold(
            key: scaffoldKey,
            body: Stack(
              children: <Widget>[
                Container(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Select Language",
                              style: TextStyle(fontSize: 22),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: StadiumBorder(),
                                color: Color(0xffbf9b30),
                                onPressed: () {
                                  setState(() {
                                    china = false;
                                    english = true;
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      "English",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )),
                                    Icon(
                                      Icons.done,
                                      color: english == true
                                          ? Colors.white
                                          : Color(0xffbf9b30),
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                shape: StadiumBorder(),
                                color: Color(0xffbf9b30),
                                onPressed: () {
                                  setState(() {
                                    china = true;
                                    english = false;
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      "中文",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )),
                                    Icon(
                                      Icons.done,
                                      color: china == true
                                          ? Colors.white
                                          : Color(0xffbf9b30),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          shape: StadiumBorder(),
                          color: Colors.pink,
                          onPressed: () {
                            if (english == false && china == false) {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Please select any language")));
                            } else if (english == true) {
                              setState(() {
                                isLoading = true;
                              });
                              appLanguage.changeLanguage(Locale("en"));
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }), (Route<dynamic> route) => false);
                            } else if (china == true) {
                              setState(() {
                                isLoading = true;
                              });
                              appLanguage.changeLanguage(Locale("zh"));
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }), (Route<dynamic> route) => false);
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                "Confirm",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )),
                            ],
                          )),
                    ],
                  ),
                )

                    /*ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text("English"),
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          appLanguage.changeLanguage(Locale("en"));
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }), (Route<dynamic> route) => false);
                        },
                      ),
                      ListTile(
                        title: Text("中文"),
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          appLanguage.changeLanguage(Locale("zh"));
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }), (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),*/
                    ),
                Positioned.fill(
                    child: isLoading
                        ? Container(
                            color: Colors.black54,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox())
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
