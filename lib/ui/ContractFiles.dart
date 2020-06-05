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

  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);

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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    print(widget.contartSnapshot["doc_1"]);
                    if(widget.contartSnapshot["doc_1"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_1"]);
                      }));
                    }
                  },
                  child: Text(
                    "1. Passport",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_2"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_2"],);
                      }));
                    };

                  },
                  child: Text(
                    "2. Employer Bank in receipt",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_3"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_3"],);
                      }));
                    }
                  },
                  child: Text(
                    "3. Standard Services Agreement",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_4"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_4"],);
                      }));
                    }
                  },
                  child: Text(
                    "4. Maid received of the Service Agreemnt and Job offer",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_5"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_5"],);
                      }));
                    }
                  },
                  child: Text(
                    "5. Employer received of SA",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_6"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_6"],);
                      }));
                    }
                  },
                  child: Text(
                    "6. Employer - Hong Kong Identity Card (HKID)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_7"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_7"],);
                      }));
                    }

                  },
                  child: Text(
                    "7. the latest 3 months address (Utility bills)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_8"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_8"],);
                      }));
                    }
                  },
                  child: Text(
                    "8. the latest Tax Demand Note or last 3 months auto-payment of Salary Statement or Fixed Deposit",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_9"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_9"],);
                      }));
                    }
                  },
                  child: Text(
                    "9. Complete list and information of household members. (Full name, year of birth, relationship and HKIC no.)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_10"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_10"],);
                      }));
                    }
                  },
                  child: Text(
                    "10. Other supporting documents that may need",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_11"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_11"],);
                      }));
                    }
                  },
                  child: Text(
                    "11. Hong Kong Identity Card (HKID) of all previous and existing helper",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_12"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_12"],);
                      }));
                    }
                  },
                  child: Text(
                    "12. Notarized Employment Contract of all previous and existing helper.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_13"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_13"],);
                      }));
                    }
                  },
                  child: Text(
                    "13. Released or Termination Letter (ID407E) of all previous helper.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_14"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_14"],);
                      }));
                    }
                  },
                  child: Text(
                    "14. Maid - Photocopy of Passport (with at least 1 year validity)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_15"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_15"],);
                      }));
                    }
                  },
                  child: Text(
                    "15. Maid - Original copy of Certificate of Employment for 2 years working as domestic helper",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_16"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_16"],);
                      }));
                    }
                  },
                  child: Text(
                    "16. Maid - Photocopy of Hong Kong Identity Card (HKID)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_17"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_17"],);
                      }));
                    }
                  },
                  child: Text(
                    "17. Maid - Photocopy of previous Notarized Hong Kong Employment Contract (ID407)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_18"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_18"],);
                      }));
                    }
                  },
                  child: Text(
                    "18. Maid - Photocopy of duly signed Termination or Release Letter (ID407E)",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_19"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_19"],);
                      }));
                    }
                  },
                  child: Text(
                    "19. Maid - Other supporting documents that may need",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_20"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_20"],);
                      }));
                    }
                  },
                  child: Text(
                    "20. Pick up checklist",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:GestureDetector(
                  onTap:(){
                    if(widget.contartSnapshot["doc_21"]!=""){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FileReaderPage(filePath: widget.contartSnapshot["doc_21"],);
                      }));
                    }
                  },
                  child: Text(
                    "21. Maid - Old Passport",
                    style: TextStyle(
                      fontSize: 18,
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
