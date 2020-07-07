import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/Models/ContractModel.dart';
import 'package:flutter_mmhelper/Models/ContractStatus.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class AgencyDetailPage extends StatefulWidget {
  @override
  final String price;
  final String type;
  final String proId;
  final String natype;
  DocumentSnapshot agencySnapshot;
  AgencyDetailPage({this.agencySnapshot,this.price,this.type,this.proId,this.natype});
  _AgencyDetailPageState createState() => _AgencyDetailPageState();
}

class _AgencyDetailPageState extends State<AgencyDetailPage>{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  final _service = FirestoreService.instance;
  String datenow= DateTime.now().toIso8601String();
  SharedPreferences prefs;
  String userid = "";
  bool isCheck = false;
  bool isConfirm = false;

  @override
  void initState() {
    super.initState();
    print("this is ${widget.agencySnapshot["FCSR_service2"]}");
  }

  void _changed(isCheck1) {
    setState(() {
      isCheck = isCheck1;
    });
  }

  Future<void> _submit() async {
    String year = DateTime.now().year.toString().substring(2);
    String month = DateTime.now().month.toString().padLeft(2,'0');
    String day =DateTime.now().day.toString().padLeft(2,'0');
    String hour =TimeOfDay.now().hour.toString().padLeft(2,'0');
    String minute =TimeOfDay.now().minute.toString().padLeft(2,'0');
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
      contract_id: widget.agencySnapshot["contract_code"]+"-"+year+month+day+hour+minute,
    );
    await Firestore.instance.collection("mb_contract").add(procontext.toMap()).then((data) async{
      print("this is ${data.documentID}");
      procontext.id = data.documentID;
      await _service.setData(path: APIPath.newContract(data.documentID),
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
        await Firestore.instance.collection("mb_contract_status").add(contractstatustext.toMap()).then((datas) async{
          contractstatustext.id = datas.documentID;
          await _service.setData(path: APIPath.newContractStatus(datas.documentID),
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
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5), // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10,0, 0),
                        child:Text(
                          "Section 1 -Discription",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    widget.type=="Terminated"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Terminated_text"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String type_text = widget.agencySnapshot["Terminated_text"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            type_text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Overseas"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Overseas_text"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String type_text = widget.agencySnapshot["Overseas_text"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            type_text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Finished"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Finished_text"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String type_text = widget.agencySnapshot["Finished_text"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            type_text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="FCSR"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["FCSR_text"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String type_text = widget.agencySnapshot["FCSR_text"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            type_text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10,0, 0),
                        child:Text(
                          "Section 2 -服務內容",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    widget.type=="Terminated" && widget.natype=="Philipino"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Terminated_service2"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Terminated_service2"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Finished"&& widget.natype=="Philipino"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Finished_service2"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Finished_service2"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Overseas" && widget.natype=="Philipino"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Overseas_service2"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Overseas_service2"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="FCSR"&& widget.natype=="Philipino"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["FCSR_service2"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["FCSR_service2"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),

                    widget.type=="Terminated" && widget.natype=="Indonesian"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Terminated_service1"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Terminated_service1"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Finished"&& widget.natype=="Indonesian"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Finished_service1"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Finished_service1"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="Overseas" && widget.natype=="Indonesian"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["Overseas_service1"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["Overseas_service1"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),
                    widget.type=="FCSR"&& widget.natype=="Indonesian"?ListView.separated(
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
                      itemCount: widget.agencySnapshot["FCSR_service1"].length,
                      itemBuilder: (BuildContext context, int index) {
                        String workinfo = widget.agencySnapshot["FCSR_service1"][index];
                        return Padding(
                          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Text(
                            workinfo,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ):Text(""),

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
                          "This Job offer will be sent to the helper, we will notify you once it is accepted and you may continue the payment process with the agency directly and tracking the process in the app.",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: isCheck,
                      onChanged: _changed,
                      activeColor:gradientStart,
                      activeTrackColor:gradientEnd,
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Checkbox(
                          value: isConfirm,
                          onChanged: (newValue) {
                            setState(() {
                              isConfirm = newValue;
                            });
                          }),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16, color: Colors.black87),
                            text: "I consent to Search4maid using my personal data to for direct marketing activities refer to",
                            children: [
                              TextSpan(
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                text: " Privacy Policy",
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () async {
                                    if (await canLaunch(
                                        "https://www.search4maid.com/privacy.html")) {
                                      await launch(
                                          "https://www.search4maid.com/privacy.html");
                                    } else {
                                      throw 'Could not launch https://www.search4maid.com/privacy.html';
                                    }
                                  },
                              ),
                              TextSpan(text: " &"),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  text: " Terms and Conditions",
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await canLaunch(
                                          "https://www.search4maid.com/terms.html")) {
                                        await launch(
                                            "https://www.search4maid.com/terms.html");
                                      } else {
                                        throw 'Could not launch https://www.search4maid.com/terms.html';
                                      }
                                    }),
                              TextSpan(
                                  text:". It may include direct marketing from Serach4maid or our business partners."
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        if(isCheck ==true && isConfirm == true){
                          _submit();
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(
                              content: Text(
                                "The request has been submitted.",
                              )));
                        }else if(isCheck ==false){
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(
                              content: Text(
                                "Did not agree to send notification to helper.",
                              )));
                        }else if(isConfirm == false){
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(
                              content: Text(
                                "Please agree to the terms.",
                              )));
                        }

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
