import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/ui/AgencyListPage.dart';
import 'package:flutter_mmhelper/ui/widgets/photpGalleryPage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileDateil extends StatefulWidget {
  @override
  _ProfileDateilState createState() => _ProfileDateilState();

  // DocumentSnapshot proSnapshot;
  ProfileData profileData;
  String languageCode;
  ProfileDateil({/*this.proSnapshot,*/ this.profileData, this.languageCode});
}

class _ProfileDateilState extends State<ProfileDateil> {
  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981);
  DataListService dataListService;


  @override
  Widget build(BuildContext context) {
    dataListService = Provider.of<DataListService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientStart,
        title: Text(
          AppLocalizations.of(context).translate('Profile_Detail'),
          style: TextStyle(
            color: Colors.black,
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
//                padding: const EdgeInsets.all(10),
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
                          return AgencyListpage(
                            nationality: widget.profileData.nationality,
                            contract: widget.profileData.contract,
                            protid: widget.profileData.id.toString(),
                          );
                        }));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: gradientStart,
                      child: Text(
                        AppLocalizations.of(context).translate('Hire'),
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
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                          },
                          icon: Icon(
                            Icons.star,
                            color: Colors.grey,
                          ),
                          iconSize: 30,
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Text(
                            "Favourite",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: (){},
                          icon: Icon(
                            Icons.chat,
                            color: gradientStart,
                          ),
                          iconSize: 30,
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Text(
                            "Chat",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Basic_Information'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
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
                                          color: Colors.black.withOpacity(0.7),
                                          size: 20,
                                        ),
                                        Text(
                                          " ${AppLocalizations.of(context).translate('FirstName')}:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
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
                                          color: Colors.black.withOpacity(0.7),
                                          size: 20,
                                        ),
                                        Text(
                                          " ${AppLocalizations.of(context).translate('LastName')}:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 10),
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
//                    Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(10),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.flag,
//                                  size: 20,
//                                  color: Colors.black.withOpacity(0.7),
//                                ),
//                                Text(
//                                  " ${AppLocalizations.of(context).translate('UserName')}:",
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                    color: Colors.black.withOpacity(0.7),
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ],
//                            ),
//                            Padding(
//                                padding:
//                                const EdgeInsets.only(left: 20, top: 10),
//                                child: Text(
//                                  /*widget.proSnapshot['nationaity'] !=
//                                      "Select"
//                                      ? widget.proSnapshot['nationaity']
//                                      : "",*/
//                                  dataListService.getNationalityValue(
//                                      languageCode: widget.languageCode,
//                                      nationality:
//                                      widget.profileData.username ?? ""),
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                  ),
//                                ))
//                          ],
//                        ),
//                      ),
//                    ),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Gender')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                //widget.proSnapshot['gender'],
                                AppLocalizations.of(context)
                                    .translate(widget.profileData.gender),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Birthday')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                widget.profileData.birthday != "" &&
                                        widget.profileData.birthday != null
                                    ? DateFormat.yMMMMEEEEd()
                                        .format(widget.profileData.birthday)
                                    : "",
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Nationality')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['nationaity'] !=
                                      "Select"
                                      ? widget.proSnapshot['nationaity']
                                      : "",*/
                                  dataListService.getNationalityValue(
                                      languageCode: widget.languageCode,
                                      nationality:
                                          widget.profileData.nationality ?? ""),
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
                                  Icons.flag,
                                  size: 20,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('weight')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['nationaity'] !=
                                      "Select"
                                      ? widget.proSnapshot['nationaity']
                                      : "",*/
                                  dataListService.getNationalityValue(
                                      languageCode: widget.languageCode,
                                      nationality:
                                      widget.profileData.weight ?? ""),
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
                                  Icons.flag,
                                  size: 20,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('height')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['nationaity'] !=
                                      "Select"
                                      ? widget.proSnapshot['nationaity']
                                      : "",*/
                                  dataListService.getNationalityValue(
                                      languageCode: widget.languageCode,
                                      nationality:
                                      widget.profileData.height ?? ""),
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
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Detail_Information'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Education')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['education'] != "Select"
                                    ? widget.proSnapshot['education']
                                    : "",*/
                                dataListService.getEducationValue(
                                    languageCode: widget.languageCode,
                                    education:
                                        widget.profileData.education ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Religion')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['religion'] != "Select"
                                    ? widget.proSnapshot['religion']
                                    : "",*/
                                dataListService.getReligionValue(
                                    languageCode: widget.languageCode,
                                    religion:
                                        widget.profileData.religion ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Marital_Status')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['marital'] != "Select"
                                    ? widget.proSnapshot['marital']
                                    : "",*/
                                dataListService.getMaritalValue(
                                    languageCode: widget.languageCode,
                                    marital: widget.profileData.marital ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Children')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['children'] !=
                                                "Select"
                                            ? widget.proSnapshot['children']
                                            : "",*/
                                  dataListService.getChildrenValue(
                                      languageCode: widget.languageCode,
                                      children:
                                          widget.profileData.children ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Current_Location')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /* widget.proSnapshot['current'] !=
                                                "Select"
                                            ? widget.proSnapshot['current']
                                            : "",*/
                                  dataListService.getCurrentLocationValue(
                                      languageCode: widget.languageCode,
                                      location:
                                          widget.profileData.current ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('address')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /* widget.proSnapshot['current'] !=
                                                "Select"
                                            ? widget.proSnapshot['current']
                                            : "",*/
                                  dataListService.getCurrentLocationValue(
                                      languageCode: widget.languageCode,
                                      location:
                                      widget.profileData.address ?? ""),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
//                    Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(10),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.chat_bubble,
//                                  size: 20,
//                                  color: Colors.black.withOpacity(0.7),
//                                ),
//                                Text(
//                                  " ${AppLocalizations.of(context).translate('Whatsapp_Number')}:",
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                    color: Colors.black.withOpacity(0.7),
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ],
//                            ),
//                            Padding(
//                                padding:
//                                    const EdgeInsets.only(left: 20, top: 10),
//                                child: Text(
//                                  /*widget.proSnapshot['whatsapp'] !=
//                                                "+85263433995"
//                                            ? widget.proSnapshot['whatsapp']
//                                            : "",*/
//                                  widget.profileData.whatsapp ?? "",
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                  ),
//                                ))
//                          ],
//                        ),
//                      ),
//                    ),
//                    Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(10),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.phone,
//                                  size: 20,
//                                  color: Colors.black.withOpacity(0.7),
//                                ),
//                                Text(
//                                  " ${AppLocalizations.of(context).translate('Phone_number')}:",
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                    color: Colors.black.withOpacity(0.7),
//                                    fontWeight: FontWeight.bold,
//                                  ),
//                                ),
//                              ],
//                            ),
//                            Padding(
//                                padding:
//                                    const EdgeInsets.only(left: 20, top: 10),
//                                child: Text(
//                                  /*widget.proSnapshot['phone'] !=
//                                                "+85263433995"
//                                            ? widget.proSnapshot['phone']
//                                            : "",*/
//                                  widget.profileData.phone ?? "",
//                                  style: TextStyle(
//                                    fontSize: 18,
//                                  ),
//                                ))
//                          ],
//                        ),
//                      ),
//                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Work_Information'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Job_Type')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['jobtype'] != "Select"
                                    ? widget.proSnapshot['jobtype']
                                    : "",*/
                                dataListService.getJobTypeValue(
                                    languageCode: widget.languageCode,
                                    jobtype: widget.profileData.jobtype ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Job_Capacity')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['jobcapacity'] != "Select"
                                    ? widget.proSnapshot['jobcapacity']
                                    : "",*/
                                dataListService.getJobCapacityValue(
                                    languageCode: widget.languageCode,
                                    jobcapacity:
                                        widget.profileData.jobcapacity ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Contract_Status')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /* widget.proSnapshot['contract'] != "Select"
                                    ? widget.proSnapshot['contract']
                                    : "",*/
                                dataListService.getContractValue(
                                    languageCode: widget.languageCode,
                                    contract:
                                        widget.profileData.contract ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Working_Skill')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['workskill'] !=
                                                "Select"
                                            ? widget.proSnapshot['workskill']
                                            : "",*/
                                  dataListService.getWorkSkillValue(
                                      languageCode: widget.languageCode,
                                      workskill:
                                          widget.profileData.workskill ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Language')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  /*widget.proSnapshot['language'] !=
                                                "Select"
                                            ? widget.proSnapshot['language']
                                            : "",*/
                                  dataListService.getLanguageValue(
                                      languageCode: widget.languageCode,
                                      language:
                                          widget.profileData.language ?? ""),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Expected_Salary_HKD')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
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
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Text(
                                  " ${AppLocalizations.of(context).translate('Employement_Start_Date')}:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                /*widget.proSnapshot['employment'] != "Select"
                                    ? widget.proSnapshot['employment']
                                    : "",*/
                                widget.profileData.employment != "" &&
                                        widget.profileData.employment != null
                                    ? DateFormat.yMMMMEEEEd()
                                        .format(widget.profileData.employment)
                                    : "",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Self_Introduction'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('Work_Experience'),
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        )),
                    Container(
                      child:
                          /*widget.proSnapshot["workexperiences"] != null ||
                              widget.proSnapshot["workexperiences"][0] != null*/
                          widget.profileData.workexperiences.length != 0
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
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5, //宽度
                                                color: Colors.grey //边框颜色
                                                ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "#${AppLocalizations.of(context).translate('Work_Experience')}${index + 1}#",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
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
                                                          Icons.edit_location,
                                                          size: 20,
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                        Text(
                                                          "${AppLocalizations.of(context).translate('Country')}:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
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
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  " ${AppLocalizations.of(context).translate('Start_Date')}:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
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
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  " ${AppLocalizations.of(context).translate('End_Date')}:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.7),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
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
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                        Text(
                                                          " ${AppLocalizations.of(context).translate('Type_of_Jobs')}:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
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
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                        Text(
                                                          " ${AppLocalizations.of(context).translate('Number_of_Taken_Care')}:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
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
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                        Text(
                                                          " ${AppLocalizations.of(context).translate('Quit_Reason')}:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
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
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                        ),
                                                        Text(
                                                          " ${AppLocalizations.of(context).translate('Reterence_Letter')}:",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
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
                                  child: Text(AppLocalizations.of(context)
                                      .translate('No_Work_Experiences')),
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
