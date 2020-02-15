import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Container(
        child: Center(
          child: FlatButton(
            onPressed: () {
              _firebaseAuth.signOut();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }), (Route<dynamic> route) => false);
            },
            child: Text("Logout",style: TextStyle(color: Colors.white),),
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}
