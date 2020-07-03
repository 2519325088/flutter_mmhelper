import 'package:flutter/material.dart';

class CustomPopupProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomPopupProfileState();
  final GestureTapCallback onTap;
  final WillPopCallback onWillTap;
  final String title;
  final String titletwo;
  final String message;
  final String messageone;


  CustomPopupProfile({this.message, this.onTap, this.title, this.onWillTap,this.titletwo,this.messageone});
}

class CustomPopupProfileState extends State<CustomPopupProfile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.titletwo,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              widget.message,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                            child: Text(
                              widget.messageone,
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  onPressed: widget.onTap,
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
