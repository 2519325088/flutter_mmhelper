import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mmhelper/ui/AgencyDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class AgencyListpage extends StatefulWidget {
  @override
  _AgencyListpageState createState() => _AgencyListpageState();

  final String nationality;
  final String contract;
  final String protid;
  AgencyListpage({this.nationality,this.contract,this.protid});
}

class _AgencyListpageState extends State<AgencyListpage> {

  final width = window.physicalSize.width;
  final height = window.physicalSize.height;
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
          "Agency List",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('mb_agency')
                .where("type", isEqualTo: "contract")
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
          }
        ),
      ),
    );
  }


  Widget agenxyCard(
      {DocumentSnapshot agencySnapshot,}) {
    var aa = double.parse((agencySnapshot["score"]!="" && agencySnapshot["score"]!=null)? agencySnapshot["score"]:"1");
    var price = "";
    var type="";
    if(widget.nationality=="Philippines" && widget.contract =="Terminated / Break"){
      price = agencySnapshot["pricing"]["Philipino"]["Terminated"];
      type = "Terminated";
    }else if(widget.nationality=="Philippines" && (widget.contract =="Ex-HK" || widget.contract =="Ex-Overseas" || widget.contract =="First Time Overseas")){
      price = agencySnapshot["pricing"]["Philipino"]["Overseas"];
      type = "Overseas";
    }else if(widget.nationality=="Philippines" && widget.contract =="Finish Contract"){
      price = agencySnapshot["pricing"]["Philipino"]["Finished"];
      type = "Finished";
    }else if(widget.nationality=="Philippines" && widget.contract =="Finish Contract with Special Reason"){
      price = agencySnapshot["pricing"]["Philipino"]["FCSR"];
      type = "FCSR";
    }else if (widget.nationality=="Indonesia" && widget.contract =="Terminated / Break"){
      price = agencySnapshot["pricing"]["Indonesian"]["Terminated"];
      type = "Terminated";
    }else if(widget.nationality=="Indonesia" && (widget.contract =="Ex-HK" || widget.contract =="Ex-Overseas" || widget.contract =="First Time Overseas")){
      price = agencySnapshot["pricing"]["Indonesian"]["Overseas"];
      type = "Overseas";
    }else if(widget.nationality=="Indonesia" && widget.contract =="Finish Contract"){
      price = agencySnapshot["pricing"]["Indonesian"]["Finished"];
      type = "Finished";
    }else if(widget.nationality=="Indonesia" && widget.contract =="Finish Contract with Special Reason"){
      price = agencySnapshot["pricing"]["Indonesian"]["FCSR"];
      type = "FCSR";
    }else{
      print(widget.contract);
      price = agencySnapshot["pricing"]["Indonesian"]["FCSR"];
      type = "FCSR";
    }
    return Card(
      child: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 6,
              child:Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 80,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AgencyDetailPage(agencySnapshot: agencySnapshot,price: price,type: type,proId: widget.protid,);
                        }));
                      },
                      child: new Image.network(
                        agencySnapshot["logo"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () async{
                        if (await canLaunch(agencySnapshot["ec_url"])) {
                          await launch(agencySnapshot["ec_url"]);
                        } else {
                          throw 'Could not launch ${agencySnapshot["ec_url"]}';
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            "用戶評分 : ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            color: Colors.black45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                (0<= aa && aa<1 )?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                                (1<=aa && aa <2)?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: width<500?16:18,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                                (2<=aa && aa <3)?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                                (3<=aa && aa <4)?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                                (4<=aa && aa<5)?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                                aa== 5?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: width<500?14:18,
                                    ),
                                    Text(
                                      agencySnapshot["score"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ):Text(""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex:3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: width<500?18:20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Text(
                      "收費詳情",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return AgencyDetailPage(agencySnapshot: agencySnapshot,price: price,type: type,proId: widget.protid,);
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

}
