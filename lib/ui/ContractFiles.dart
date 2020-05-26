import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';

class ContractFiles extends StatefulWidget {
  @override
  _ContractFilesState createState() => _ContractFilesState();
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
                    print("第一文件");
                  },
                  child: Text(
                    "1.Passport",
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
                child:Text(
                  "2.Employer Bank in receipt",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "3.Standard Services Agreement",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "4.Maid received of the Service Agreemnt and Job offer",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "5.Employer received of SA",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "6.Employer - Hong Kong Identity Card (HKID)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "7.the latest 3 months address (Utility bills)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "8.the latest Tax Demand Note or last 3 months auto-payment of Salary Statement or Fixed Deposit",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "9.Complete list and information of household members. (Full name, year of birth, relationship and HKIC no.)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "10.Other supporting documents that may need",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "11.Hong Kong Identity Card (HKID) of all previous and existing helper",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "12.Notarized Employment Contract of all previous and existing helper.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "13.Released or Termination Letter (ID407E) of all previous helper.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "14.Maid - Photocopy of Passport (with at least 1 year validity)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "15.Maid - Original copy of Certificate of Employment for 2 years working as domestic helper",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "16.Maid - Photocopy of Hong Kong Identity Card (HKID)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "17.Maid - Photocopy of previous Notarized Hong Kong Employment Contract (ID407)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "18.Maid - Photocopy of duly signed Termination or Release Letter (ID407E)",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "19.Maid - Other supporting documents that may need",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "20.Pick up checklist",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child:Text(
                  "21.Maid - Old Passport",
                  style: TextStyle(
                    fontSize: 18,
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
