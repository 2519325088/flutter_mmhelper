import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';

class ProfileDateil extends StatefulWidget {
  @override
  _ProfileDateilState createState() => _ProfileDateilState();

  DocumentSnapshot proSnapshot;
  ProfileDateil({this.proSnapshot});
}

class _ProfileDateilState extends State<ProfileDateil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.pink,
        title: Text(
          'Profile Dateil',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        /*leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),*/
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
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
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        Text(
                                          "FirstName:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        widget.proSnapshot['firstname'],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        Text(
                                          "LastName:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        widget.proSnapshot['lastname'],
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.wc,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Gender:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['gender'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Birthday:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['birthday']!="Select"?widget.proSnapshot['birthday']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.flag,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Nationaity:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['nationaity']!="Select"?widget.proSnapshot['nationaity']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
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
                  children: <Widget>[
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Education:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['education']!="Select"?widget.proSnapshot['education']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.turned_in,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Religion:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['religion']!="Select"?widget.proSnapshot['religion']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.group,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Marital Status:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['marital']!="Select"?widget.proSnapshot['marital']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.child_care,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Chilren:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['children']!="Select"?widget.proSnapshot['children']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.edit_location,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Current Location:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['current']!="Select"?widget.proSnapshot['current']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.chat_bubble,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "WhatsApp:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['whatsapp']!="+85263433995"?widget.proSnapshot['whatsapp']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Phone Number:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['phone']!="+85263433995"?widget.proSnapshot['phone']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
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
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.work,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Job Type:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['jobtype']!="Select"?widget.proSnapshot['jobtype']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Job Capacity:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['jobcapacity']!="Select"?widget.proSnapshot['jobcapacity']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.assignment_late,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Contract Status:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['contract']!="Select"?widget.proSnapshot['contract']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.apps,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Working Skills:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: widget.proSnapshot['workskill']!=null?Text(
                                widget.proSnapshot['workskill']!="Select"?widget.proSnapshot['workskill']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ):Text("")
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.chat,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Languages:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: widget.proSnapshot['language']!=null?Text(
                                widget.proSnapshot['language']!="Select"?widget.proSnapshot['language']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ):Text("")
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "ExpectedSalary(HKD):",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['expectedsalary']!="Select"?widget.proSnapshot['expectedsalary']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child:Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Employment Start Date:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),

                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text(
                                widget.proSnapshot['employment']!="Select"?widget.proSnapshot['employment']:"",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
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
                child:Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.assignment,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            "Self introduction:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 10),
                        child: widget.proSnapshot['selfintroduction']!=null?Text(
                          widget.proSnapshot['selfintroduction'],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ):Text("")
                      )
                    ],
                  ),
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
                child:widget.proSnapshot["workexperiences"]!=null?ListView.separated(
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
                  itemCount: widget.proSnapshot["workexperiences"].length,
                  itemBuilder: (BuildContext context, int index) {
                    Map workinfo = widget.proSnapshot["workexperiences"][index];
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black, width: 0.5), // 边色与边宽度
                          borderRadius: new BorderRadius.circular((20.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.edit_location,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Country:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        workinfo["country"] !="Select"?workinfo["country"]:"",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Start Date:",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 10),
                                              child: Text(
                                                workinfo["start"] !="Select"?workinfo["start"]:"",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "End Date:",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10,top: 10),
                                              child: Text(
                                                workinfo["end"] !="Select"?workinfo["end"]:"",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.work,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Type of Jobs:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        workinfo["jobtype"] !="Select"?workinfo["jobtype"]:"",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.assignment,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Number of Taken Care:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        workinfo["taken"] !="Select"?workinfo["taken"]:"",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.assignment_late,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Quit Reason:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        workinfo["reason"] !="Select"?workinfo["reason"]:"",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.bookmark,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          "Reterence Letter:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),

                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 10),
                                      child: Text(
                                        workinfo["reterence"] !="Select"?workinfo["reterence"]:"",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ):Text("No Work Experiences"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
