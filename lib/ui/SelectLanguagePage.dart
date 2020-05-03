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
            appBar: AppBar(
              title: Text("Select your language"),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  child: ListView(
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
                  ),
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
