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
  bool english = true;
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

  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return isSelectLanguage
        ? Scaffold(
            key: scaffoldKey,
            body: Stack(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [gradientStart, gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Select Language 選擇語言",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                FlatButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: StadiumBorder(),
                                    color: Colors.white,
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
                                              fontSize: 18,
                                              color: Color(0xffbf9b30)),
                                        )),
                                        Icon(
                                          Icons.done,
                                          color: english == true
                                              ? Color(0xffbf9b30)
                                              : Colors.white,
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 12,
                                ),
                                /*FlatButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    shape: StadiumBorder(),
                                    color: Colors.white,
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
                                              fontSize: 18,
                                              color: Color(0xffbf9b30)),
                                        )),
                                        Icon(
                                          Icons.done,
                                          color: china == true
                                              ? Color(0xffbf9b30)
                                              : Colors.white,
                                        )
                                      ],
                                    ))*/
                              ],
                            ),
                          ),
                          FlatButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              shape: StadiumBorder(),
                              color: Colors.white,
                              onPressed: () {
                                if (english == false && china == false) {
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please select any language")));
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
                                        fontSize: 18, color: Color(0xffbf9b30)),
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
