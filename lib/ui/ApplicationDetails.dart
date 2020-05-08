import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:flutter/cupertino.dart';

class ApplicationDetails extends StatefulWidget {
  @override
  _ApplicationDetailsState createState() => _ApplicationDetailsState();
}

class _ApplicationDetailsState extends State<ApplicationDetails> {

  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
          "Application Details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          RaisedButton(
            color: gradientStart,
            onPressed: (){},
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              alignment: FractionalOffset.centerRight,
              child: Text(
                "Ret.No.01000024",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1,//宽度
                              color: Colors.grey, //边框颜色
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.account_box,
                              color: Colors.grey,
                              size: 36,
                            ),
                          ),
                          Text(
                            "Contact info",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              width: 1,//宽度
                              color: Colors.grey, //边框颜色
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.assignment,
                              color: Colors.grey,
                              size: 36,
                            ),
                          ),
                          Text(
                            "Empolayer info",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.assignment,
                              color: Colors.grey,
                              size: 36,
                            ),
                          ),
                          Text(
                            "Helper info",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Application Details',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child:ListView.separated(
                shrinkWrap: true,
                physics:const ScrollPhysics(),
                padding: EdgeInsets.all(10),
                separatorBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Divider(),
                    ),
                  );
                },
                itemCount: applications.length,
                itemBuilder: (BuildContext context, int index) {
                  Map appinfo = applications[index];
                  return new Stack(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: new Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: new Container(
                              width: double.infinity,
                              height: 200.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "${index+1} ",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            appinfo["title"],
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: gradientStart,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            index==0?"5 May 2020":"To be done",
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                              child: Container(
                                                width: 70,
                                                height: 26,
                                                child: FlatButton(
                                                  onPressed:(){},
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  color: gradientStart,
                                                  child:Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    appinfo["text"],
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        appinfo["time"],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Text(
                                          "View more",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        onTap: (){},
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        top: 0.0,
                        bottom: 0.0,
                        left: 10.0,
                        child: new Container(
                          height: double.infinity,
                          width: 1.0,
                          color: Colors.blue,
                        ),
                      ),
                      new Positioned(
                        top: 100.0,
//                        left: 5.0,
                        child: new Container(
                          height: 20.0,
                          width: 20.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: new Container(
                            margin: new EdgeInsets.all(5.0),
                            height: 10.0,
                            width: 10.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(width: 2, color: Colors.red),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
