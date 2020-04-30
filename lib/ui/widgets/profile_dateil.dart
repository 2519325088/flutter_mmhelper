import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_mmhelper/ui/AgencyListPage.dart';
import 'package:flutter_mmhelper/ui/widgets/photpGalleryPage.dart';

class ProfileDateil extends StatefulWidget {
  @override
  _ProfileDateilState createState() => _ProfileDateilState();

  // DocumentSnapshot proSnapshot;
  ProfileData profileData;

  ProfileDateil({/*this.proSnapshot,*/ this.profileData});
}

class _ProfileDateilState extends State<ProfileDateil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          'Profile Detail',
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
                padding: const EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  //解决 listview 嵌套报错
                  physics: NeverScrollableScrollPhysics(),
                  //禁用滑动事件
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 3,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PhotpGalleryPage(
                            index: index,
                            //photoList:widget.proSnapshot["imagelist"],);
                            photoList: widget.profileData.imagelist,
                          );
                        }));
                      },
                      child: Image.network(
                        //widget.proSnapshot["imagelist"][index],
                        widget.profileData.imagelist[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  //itemCount: widget.proSnapshot["imagelist"].length,
                  itemCount: widget.profileData.imagelist.length,
                ),
//                child:widget.proSnapshot["imagelist"]!=null || widget.proSnapshot["imagelist"][0]!=null?GridView.builder(
//                  shrinkWrap: true,
//                  physics: NeverScrollableScrollPhysics(),
//                  primary: false,
//                  padding: EdgeInsets.all(5),
//                  itemCount: widget.proSnapshot["imagelist"].length,
//                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 3,
//                    childAspectRatio: 200 / 200,
//                  ),
//                  itemBuilder: (BuildContext context, int index) {
//                    return Padding(
//                      padding: EdgeInsets.all(5.0),
//                      child: Image.network(
//                        widget.proSnapshot["imagelist"][index],
//                        fit: BoxFit.cover,
//                      ),
//                    );
//                  },
//                ):Text("No Image"),
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
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AgencyListpage();
                        }));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.pinkAccent,
                      child: Text(
                        'Hire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Text(
                                        //widget.proSnapshot['firstname'],
                                        widget.profileData.firstname,
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Text(
                                        // widget.proSnapshot['lastname'],
                                        widget.profileData.lastname,
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
                      child: Padding(
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                //widget.proSnapshot['gender'],
                                widget.profileData.gender,
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                DateFormat.yMMMMEEEEd()
                                    .format(widget.profileData.birthday),
                                //widget.proSnapshot['birthday']!="Select"?widget.proSnapshot['birthday']:"",
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['nationaity'] !=
                                      "Select"
                                      ? widget.proSnapshot['nationaity']
                                      : "",*/
                                  widget.profileData.nationaity ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
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
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['education'] != "Select"
                                    ? widget.proSnapshot['education']
                                    : "",*/
                                widget.profileData.education ?? "",
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['religion'] != "Select"
                                    ? widget.proSnapshot['religion']
                                    : "",*/
                                widget.profileData.religion ?? "",
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['marital'] != "Select"
                                    ? widget.proSnapshot['marital']
                                    : "",*/
                                widget.profileData.marital ?? "",
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['children'] !=
                                                "Select"
                                            ? widget.proSnapshot['children']
                                            : "",*/
                                  widget.profileData.children ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /* widget.proSnapshot['current'] !=
                                                "Select"
                                            ? widget.proSnapshot['current']
                                            : "",*/
                                  widget.profileData.current ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['whatsapp'] !=
                                                "+85263433995"
                                            ? widget.proSnapshot['whatsapp']
                                            : "",*/
                                  widget.profileData.whatsapp ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['phone'] !=
                                                "+85263433995"
                                            ? widget.proSnapshot['phone']
                                            : "",*/
                                  widget.profileData.phone ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
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
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['jobtype'] != "Select"
                                    ? widget.proSnapshot['jobtype']
                                    : "",*/
                                widget.profileData.jobtype ?? "",
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['jobcapacity'] != "Select"
                                    ? widget.proSnapshot['jobcapacity']
                                    : "",*/
                                widget.profileData.jobcapacity ?? "",
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /* widget.proSnapshot['contract'] != "Select"
                                    ? widget.proSnapshot['contract']
                                    : "",*/
                                widget.profileData.contract ?? "",
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['workskill'] !=
                                                "Select"
                                            ? widget.proSnapshot['workskill']
                                            : "",*/
                                  widget.profileData.workskill ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['language'] !=
                                                "Select"
                                            ? widget.proSnapshot['language']
                                            : "",*/
                                  widget.profileData.language ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['expectedsalary'] != "Select"
                                    ? widget.proSnapshot['expectedsalary']
                                    : "",*/
                                widget.profileData.expectedsalary ?? "",
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
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                /*widget.proSnapshot['employment'] != "Select"
                                    ? widget.proSnapshot['employment']
                                    : "",*/
                                DateFormat.yMMMMEEEEd()
                                    .format(widget.profileData.employment),
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
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Padding(
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
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            //widget.proSnapshot['selfintroduction'],
                            widget.profileData.selfintroduction ?? "",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                  // 边色与边宽度
                  borderRadius: new BorderRadius.circular((20.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            "Work Experiences:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child:
                          /*widget.proSnapshot["workexperiences"] != null ||
                              widget.proSnapshot["workexperiences"][0] != null*/
                          widget.profileData.workexperiences.length == 0
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  padding: EdgeInsets.all(10),
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Divider(),
                                      ),
                                    );
                                  },
                                  itemCount:
                                      widget.profileData.workexperiences.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    /*Map workinfo = widget
                                    .proSnapshot["workexperiences"][index];*/
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Colors.black,
                                              width: 0.5), // 边色与边宽度
                                          borderRadius:
                                              new BorderRadius.circular((20.0)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        /*workinfo["country"] !=
                                                            "Select"
                                                        ? workinfo["country"]
                                                        : "",*/
                                                        widget
                                                                .profileData
                                                                .workexperiences[
                                                                    index]
                                                                .country ??
                                                            "",
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "Start Date:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                              child: Text(
                                                                /*workinfo["start"] !=
                                                                        "Select"
                                                                    ? workinfo[
                                                                        "start"]
                                                                    : "",*/
                                                                DateFormat
                                                                        .yMMMMEEEEd()
                                                                    .format(widget
                                                                        .profileData
                                                                        .workexperiences[
                                                                            index]
                                                                        .start),
                                                                style:
                                                                    TextStyle(
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .access_time,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "End Date:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                              child: Text(
                                                                /*workinfo["end"] !=
                                                                        "Select"
                                                                    ? workinfo[
                                                                        "end"]
                                                                    : "",*/
                                                                DateFormat
                                                                        .yMMMMEEEEd()
                                                                    .format(widget
                                                                        .profileData
                                                                        .workexperiences[
                                                                            index]
                                                                        .end),
                                                                style:
                                                                    TextStyle(
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
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        /*workinfo["jobtype"] !=
                                                                "Select"
                                                            ? workinfo[
                                                                "jobtype"]
                                                            : "",*/
                                                        widget
                                                                .profileData
                                                                .workexperiences[
                                                                    index]
                                                                .jobtype ??
                                                            "",
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        /*workinfo["taken"] !=
                                                                "Select"
                                                            ? workinfo["taken"]
                                                            : "",*/
                                                        widget
                                                                .profileData
                                                                .workexperiences[
                                                                    index]
                                                                .taken ??
                                                            "",
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        /*workinfo["reason"] !=
                                                                "Select"
                                                            ? workinfo["reason"]
                                                            : "",*/
                                                        widget
                                                                .profileData
                                                                .workexperiences[
                                                                    index]
                                                                .reason ??
                                                            "",
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        /*workinfo["reterence"] !=
                                                                "Select"
                                                            ? workinfo[
                                                                "reterence"]
                                                            : "",*/
                                                        widget
                                                                .profileData
                                                                .workexperiences[
                                                                    index]
                                                                .reterence ??
                                                            "",
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
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No Work Experiences"),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
