import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mmhelper/ui/AgencyDetailPage.dart';

class AgencyListpage extends StatefulWidget {
  @override
  _AgencyListpageState createState() => _AgencyListpageState();
}

class _AgencyListpageState extends State<AgencyListpage> {
  String datenow= DateTime.now().toIso8601String();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('mb_agency')
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ?ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  return agenxyCard(agencySnapshot:snapshot.data.documents[index]);
                  },
                  itemCount: snapshot.data.documents.length,
                )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),

//        child: ListView(
//          children: <Widget>[
//            ListView.separated(
//              shrinkWrap: true,
//              physics:const ScrollPhysics(),
//              padding: EdgeInsets.all(10),
//              separatorBuilder: (BuildContext context, int index) {
//                return Align(
//                  alignment: Alignment.centerRight,
//                  child: Container(
//                    height: 0.5,
//                    width: MediaQuery.of(context).size.width,
//                    child: Divider(),
//                  ),
//                );
//              },
//              itemCount: pricelists.length,
//              itemBuilder: (BuildContext context, int index) {
//                Map  price= pricelists[index];
//                return Padding(
//                  padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        flex: 6,
//                        child:Container(
//                          height: 50,
//                          width: double.infinity,
//                          child: new Image.asset(
//                            "assets/images/15-shop.jpg",
//                            fit: BoxFit.cover,
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        flex: 4,
//                        child:Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Text(
//                              "HKD${price['name']}",
//                              style: TextStyle(
//                                fontSize: 24,
//                                fontWeight: FontWeight.w800,
//                              ),
//                            ),
//                            GestureDetector(
//                              child: Text(
//                                "详情",
//                                style: TextStyle(
//                                  fontSize: 18,
//                                ),
//                              ),
//                              onTap: (){
//                                print(datenow);
////                                Navigator.of(context)
////                                    .push(MaterialPageRoute(builder: (context) {
////                                  return AgencyDetailPage();
////                                }));
//                              },
//                            ),
//                          ],
//                        )
//                      ),
//                    ],
//                  ),
//                );
//              },
//            ),
//          ],
//        ),
      ),
    );
  }


  Widget agenxyCard(
      {DocumentSnapshot agencySnapshot,}) {
    return Card(
      child: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child:Container(
                height: 50,
                width: double.infinity,
                child: new Image.asset(
                  "assets/images/15-shop.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      agencySnapshot["pricing"]["Philipino"]["MSH"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "详情",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onTap: (){
                        print(datenow);
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return AgencyDetailPage(agencySnapshot: agencySnapshot,);
                                }));
                      },
                    ),
                  ],
                )
            ),
          ],
        ),
      )
    );
  }
}
