import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mmhelper/ui/AgencyDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';

class AgencyListpage extends StatefulWidget {
  @override
  _AgencyListpageState createState() => _AgencyListpageState();

  final String nationality;
  final String contract;
  final String protid;
  AgencyListpage({this.nationality,this.contract,this.protid});
}

class _AgencyListpageState extends State<AgencyListpage> {

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
    var aa = double.parse(agencySnapshot["score"]);
    var price = "";
    var type="";
    if(widget.nationality=="Philippines" && (widget.contract =="Terminated" || widget.contract =="Break")){
      price = agencySnapshot["pricing"]["Philipino"]["Terminated"];
      type = "Terminated";
    }else if(widget.nationality=="Philippines" && (widget.contract =="Ex-HK" || widget.contract =="Ex-Overseas" || widget.contract =="First Time Overseas")){
      price = agencySnapshot["pricing"]["Philipino"]["Overseas"];
      type = "Overseas";
    }else if(widget.nationality=="Philippines" && widget.contract =="Finished"){
      price = agencySnapshot["pricing"]["Philipino"]["Finished"];
      type = "Finished";
    }else if(widget.nationality=="Philippines" && widget.contract =="Employed"){
      price = agencySnapshot["pricing"]["Philipino"]["FCSR"];
      type = "FCSR";
    }else if (widget.nationality=="Indonesia" && (widget.contract =="Terminated" || widget.contract =="Break")){
      price = agencySnapshot["pricing"]["Indonesian"]["Terminated"];
      type = "Terminated";
    }else if(widget.nationality=="Indonesia" && (widget.contract =="Ex-HK" || widget.contract =="Ex-Overseas" || widget.contract =="First Time Overseas")){
      price = agencySnapshot["pricing"]["Indonesian"]["Overseas"];
      type = "Overseas";
    }else if(widget.nationality=="Indonesia" && widget.contract =="Finished"){
      price = agencySnapshot["pricing"]["Indonesian"]["Finished"];
      type = "Finished";
    }else if(widget.nationality=="Indonesia" && widget.contract =="Employed"){
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
          children: <Widget>[
            Expanded(
              flex: 6,
              child:Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    width: double.infinity,
                    child: new Image.network(
                      agencySnapshot["logo"],
                      fit: BoxFit.cover,
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
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
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
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
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
                                (2<=aa && aa <3)?Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
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
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
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
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white70,
                                      size: 18,
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
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                      size: 18,
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
                flex: 3,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "收費詳情",
                        style: TextStyle(
                          fontSize: 18,
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
                )
            ),
          ],
        ),
      )
    );
  }

}
