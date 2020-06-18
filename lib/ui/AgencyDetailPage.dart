import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/Models/ContractModel.dart';
import 'package:flutter_mmhelper/Models/ContractStatus.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgencyDetailPage extends StatefulWidget {
  @override
  final String price;
  final String type;
  final String proId;
  DocumentSnapshot agencySnapshot;
  AgencyDetailPage({this.agencySnapshot,this.price,this.type,this.proId});
  _AgencyDetailPageState createState() => _AgencyDetailPageState();
}

class _AgencyDetailPageState extends State<AgencyDetailPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  final _service = FirestoreService.instance;
  String datenow= DateTime.now().toIso8601String();
  SharedPreferences prefs;
  final userid = "";

  Future<void> _submit() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getString("loginUid"));
//          final database = Provider.of<FirestoreDatabase>(context);
    final procontext = ContractContext(
      agency_id: widget.agencySnapshot["id"],
      contract_type: widget.type,
      created_at: DateTime.now(),
      created_by: prefs.getString("loginUid"),
      current_status: "",
      employer_id:prefs.getString("loginUid") ,
      img_receipt: "",
      id: "",
      profile_id: widget.proId,
    );
    Firestore.instance.collection("mb_contract").add(procontext.toMap()).then((data){
      print("this is ${data.documentID}");
      procontext.id = data.documentID;
      _service.setData(path: APIPath.newContract(data.documentID),
        data: procontext.toMap());
      List datalist= [
        "Submitted",
        "Paid",
        "Preparing",
        "Documents ready",
        "Processing of working visa",
        "Working Visa Active ",
        "Arrival in HK",];
      for(int i =0 ;i<7;i++){
        final contractstatustext = ContractStatusContext(
          id:"" ,
          status:datalist[i],
          process_status: "view",
          contract_id: data.documentID,
          remark: "",
        );
        Firestore.instance.collection("mb_contract_status").add(contractstatustext.toMap()).then((datas){
          contractstatustext.id = datas.documentID;
          _service.setData(path: APIPath.newContractStatus(datas.documentID),
              data: contractstatustext.toMap());
        });
      }
    });
//        Navigator.of(context)
//            .push(MaterialPageRoute(builder: (context) {
//          return LoginScreen();
//        }));
//    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
        "收費表",
        style: TextStyle(
            color: Colors.black,
        ),
      ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              child: Container(
                height: 80,
                child: Image.network(
                  widget.agencySnapshot["logo"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5), // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child:Text(
                          "中介費用",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            widget.price,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5), // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child:Text(
                          "第2選擇時間",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                            child: Text(
                              "2020-04-24",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      onPressed: (){
                        _submit();
                        scaffoldKey.currentState
                            .showSnackBar(SnackBar(
                            content: Text(
                              "The request has been submitted.",
                            )));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color:gradientStart,
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
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
