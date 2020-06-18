import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/LookFile.dart';

class ContractFiles extends StatefulWidget {
  @override
  _ContractFilesState createState() => _ContractFilesState();
  DocumentSnapshot contartSnapshot;
  ContractFiles({this.contartSnapshot});
}

class _ContractFilesState extends State<ContractFiles> {
  BorderSide borderSide = BorderSide(color: Colors.black.withOpacity(0.1));
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var storageRef = FirebaseStorage.instance
      .ref().child("/contract/FmeSuFNSdUXyuGCMMiDJ/");
    storageRef.getMetadata().then((data){
      print("this data: ${data.name}");
    });
  }

  Future<String> getContract(String skilltext) async {
    Firestore.instance
        .collection('mb_contract')
        .where("profile_id", isEqualTo: skilltext)
        .getDocuments()
        .then((snapshot) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
          "Contract",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_1"]!="" && widget.contartSnapshot["doc_1"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_1"]);
                    }));
                  }
                },
                title: Text("1. Passport"),
                trailing: widget.contartSnapshot["doc_1"]!="" && widget.contartSnapshot["doc_1"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_2"]!="" && widget.contartSnapshot["doc_2"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_2"],);
                    }));
                  }
                },
                title: Text("2. Employer Bank in receipt"),
                trailing: widget.contartSnapshot["doc_2"]!="" && widget.contartSnapshot["doc_2"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_3"]!="" && widget.contartSnapshot["doc_3"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_3"],);
                    }));
                  }
                },
                title: Text("3. Standard Services Agreement"),
                trailing: widget.contartSnapshot["doc_3"]!="" && widget.contartSnapshot["doc_3"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_4"]!="" && widget.contartSnapshot["doc_4"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_4"],);
                    }));
                  }
                },
                title: Text("4. Maid received of the Service Agreemnt and Job offer"),
                trailing: widget.contartSnapshot["doc_4"]!="" && widget.contartSnapshot["doc_4"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_5"]!="" && widget.contartSnapshot["doc_5"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_5"],);
                    }));
                  }
                },
                title: Text("5. Employer received of SA"),
                trailing: widget.contartSnapshot["doc_5"]!="" && widget.contartSnapshot["doc_5"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_6"]!="" && widget.contartSnapshot["doc_6"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_6"],);
                    }));
                  }
                },
                title: Text("6. Employer - Hong Kong Identity Card (HKID)"),
                trailing: widget.contartSnapshot["doc_6"]!="" && widget.contartSnapshot["doc_6"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_7"]!="" && widget.contartSnapshot["doc_7"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_7"],);
                    }));
                  }
                },
                title: Text("7. the latest 3 months address (Utility bills)"),
                trailing: widget.contartSnapshot["doc_7"]!="" && widget.contartSnapshot["doc_7"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_8"]!="" && widget.contartSnapshot["doc_8"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_8"],);
                    }));
                  }
                },
                title: Text("8. the latest Tax Demand Note or last 3 months auto-payment of Salary Statement or Fixed Deposit",),
                trailing: widget.contartSnapshot["doc_8"]!="" && widget.contartSnapshot["doc_8"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_9"]!="" && widget.contartSnapshot["doc_9"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_9"],);
                    }));
                  }
                },
                title: Text("9. Complete list and information of household members. (Full name, year of birth, relationship and HKIC no.)"),
                trailing: widget.contartSnapshot["doc_9"]!="" && widget.contartSnapshot["doc_9"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_10"]!="" && widget.contartSnapshot["doc_10 "]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_10"],);
                    }));
                  }
                },
                title: Text("10. Other supporting documents that may need"),
                trailing: widget.contartSnapshot["doc_10"]!="" && widget.contartSnapshot["doc_10"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_11"]!="" && widget.contartSnapshot["doc_11"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_11"],);
                    }));
                  }
                },
                title: Text("11. Hong Kong Identity Card (HKID) of all previous and existing helper"),
                trailing: widget.contartSnapshot["doc_11"]!="" && widget.contartSnapshot["doc_11"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_12"]!="" && widget.contartSnapshot["doc_12"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_12"],);
                    }));
                  }
                },
                title: Text("12. Notarized Employment Contract of all previous and existing helper."),
                trailing: widget.contartSnapshot["doc_12"]!="" && widget.contartSnapshot["doc_12"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_13"]!="" && widget.contartSnapshot["doc_13"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_13"],);
                    }));
                  }
                },
                title: Text("13. Released or Termination Letter (ID407E) of all previous helper."),
                trailing: widget.contartSnapshot["doc_13"]!="" && widget.contartSnapshot["doc_13"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_14"]!="" && widget.contartSnapshot["doc_14"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_14"],);
                    }));
                  }
                },
                title: Text("14. Maid - Photocopy of Passport (with at least 1 year validity)"),
                trailing: widget.contartSnapshot["doc_14"]!="" && widget.contartSnapshot["doc_14"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_15"]!="" && widget.contartSnapshot["doc_15"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_15"],);
                    }));
                  }
                },
                title: Text("15. Maid - Original copy of Certificate of Employment for 2 years working as domestic helper"),
                trailing: widget.contartSnapshot["doc_15"]!="" && widget.contartSnapshot["doc_15"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_16"]!="" && widget.contartSnapshot["doc_16"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_16"],);
                    }));
                  }
                },
                title: Text("16. Maid - Photocopy of Hong Kong Identity Card (HKID)"),
                trailing: widget.contartSnapshot["doc_16"]!="" && widget.contartSnapshot["doc_16"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_17"]!="" && widget.contartSnapshot["doc_17"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_17"],);
                    }));
                  }
                },
                title: Text("17. Maid - Photocopy of previous Notarized Hong Kong Employment Contract (ID407)"),
                trailing: widget.contartSnapshot["doc_17"]!="" && widget.contartSnapshot["doc_17"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_18"]!="" && widget.contartSnapshot["doc_18"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_18"],);
                    }));
                  }
                },
                title: Text("18. Maid - Photocopy of duly signed Termination or Release Letter (ID407E)"),
                trailing: widget.contartSnapshot["doc_18"]!="" && widget.contartSnapshot["doc_18"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_19"]!="" && widget.contartSnapshot["doc_19"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_19"],);
                    }));
                  }
                },
                title: Text("19. Maid - Other supporting documents that may need"),
                trailing: widget.contartSnapshot["doc_19"]!="" && widget.contartSnapshot["doc_19"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_20"]!="" && widget.contartSnapshot["doc_20"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_20"],);
                    }));
                  }
                },
                title: Text("20. Pick up checklist"),
                trailing: widget.contartSnapshot["doc_20"]!="" && widget.contartSnapshot["doc_20"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide.none,
                      left: borderSide,
                      right: borderSide,
                      bottom: borderSide)),
              child: ListTile(
                onTap: () {
                  if(widget.contartSnapshot["doc_21"]!="" && widget.contartSnapshot["doc_21"]!=null){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return FileReaderPage(filePath: widget.contartSnapshot["doc_21"],);
                    }));
                  }
                },
                title: Text("21. Maid - Old Passport"),
                trailing: widget.contartSnapshot["doc_21"]!="" && widget.contartSnapshot["doc_21"]!=null?Icon(Icons.arrow_forward_ios):Text(""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
