import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_init/after_init.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:flutter_mmhelper/ui/LoginScreen.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/nationaity.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/curren_location.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_experiences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_mmhelper/Models/ProfileFirebase.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../utils/data.dart';

class MamaProfile extends StatefulWidget {
  @override
  _MamaProfileState createState() => _MamaProfileState();
  MamaProfile({this.firstName='null',this.lastName='null',this.whatappText="null",this.phoneText="null",this.workSkill="null",this.languageText="null",this.dataIndex = -1,this.dataText="null",this.workText="null",this.genderText="null",this.salaryText="null",this.nationalityText="null",this.workHistory="null",this.cuttrenText="null"});
  int dataIndex;
  String firstName;
  String lastName;
  String dataText;
  String workText;
  String genderText;
  String workSkill;
  String languageText;
  String whatappText;
  String phoneText;
  String salaryText;
  String nationalityText;
  String workHistory;
  String cuttrenText;
}

class _MamaProfileState extends State<MamaProfile> with AfterInitMixin{
  final TextEditingController selfController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController educationTypeCtr = TextEditingController();
  final TextEditingController religionTypeCtr = TextEditingController();
  final TextEditingController maritalTypeCtr = TextEditingController();
  final TextEditingController childrenTypeCtr = TextEditingController();
  final TextEditingController jobtypeTypeCtr = TextEditingController();
  final TextEditingController jobcapacityTypeCtr = TextEditingController();
  final TextEditingController contractTypeCtr = TextEditingController();
  List<Asset> imagesa = List<Asset>();
  File locProFileImage;
  String datenow= DateTime.now().toIso8601String();
  SharedPreferences prefs;
  String _error = 'No Error Dectected';
  static Random random = Random();
  String genderdata = "Female";
  final _service = FirestoreService.instance;
  int genderRadio = -1;

  @override
  void didInitState() {
    if (widget.dataIndex != -1 && widget.dataText !="null"){
      detaills[widget.dataIndex]["text"]=widget.dataText;
    }
    if (widget.dataIndex != -1 && widget.workText !="null"){
      works[widget.dataIndex]["text"]=widget.workText;
    }
    if (widget.genderText !="null"){
      genderdata = widget.genderText;
    }
    if (widget.firstName !="null"){
      username[0] = widget.firstName;
    }
    if (widget.lastName !="null"){
      username[1] = widget.lastName;
    }
    if (widget.nationalityText !="null"){
      username[2] = widget.nationalityText;
    }
    if (widget.salaryText !="null"){
      worktexts[0] = widget.salaryText;
    }
    if (widget.workHistory !="null"){
      worktexts[2] = widget.workHistory;
    }
    if (widget.cuttrenText !="null"){
      detailltext[4] = widget.cuttrenText;
    }
    if (widget.whatappText !="null"){
      whatapptext[0] = widget.whatappText;
    }
    if (widget.phoneText !="null"){
      whatapptext[1] = widget.phoneText;
    }
    if (widget.workSkill !="null"){
      works[0]["text"]=widget.workSkill;
    }
    if (widget.workSkill ==""){
      works[0]["text"]="Select";
    }

    if (widget.languageText !="null"){
      works[1]["text"]=widget.languageText;
    }
    if (widget.languageText ==""){
      works[1]["text"]="Select";
    }
  }
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics:const ScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(imagesa.length, (index) {
        Asset asset = imagesa[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imagesa,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imagesa = resultList;
      _error = error;
    });
  }

  //  sumbit image
  Future<String> saveImage(Asset asset) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.totalByteCount);
    prefs = await SharedPreferences.getInstance();
    prefs.setString("loginUid", datenow);
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      print("this is link:$downloadUrl");
      return downloadUrl;
    });
  }

  Future<void> _submit() async {
    imageList=[];
    int i =0;
    imagesa.forEach((upFile)async{
      String downloadLink = await saveImage(upFile);
      imageList.add(downloadLink);
      i += 1;
      if(i==imagesa.length-1) {
        final database = Provider.of<FirestoreDatabase>(context);
        final procontext = ProContext(
          firstname: username[0],
          lastname: username[1],
          gender: username[3],
          birthday: datatimes,
          nationaity: username[2],
          education: detaills[0]['text'],
          religion: detaills[1]['text'],
          marital: detaills[2]['text'],
          children: detaills[3]['text'],
          current: detaills[4]['text'],
          whatsapp: whatapptext[0],
          phone: whatapptext[1],
          jobtype: worktopdata[0],
          jobcapacity: worktopdata[1],
          contract: worktopdata[2],
          workskill: works[0]['text'],
          language: works[1]['text'],
          workexperiences: workhistory,
          expectedsalary: worktexts[0],
          employment: worktexts[1],
          selfintroduction: selfController.text,
          imagelist: imageList,
        );
        _service.setData(path: APIPath.newProfile(datenow),
            data: procontext.toMap());
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    });
   // for(i =0;i<imagesa.length;i++){
   // await saveImage(imagesa[i]).then((downloadLink){
     //   imageList.add(downloadLink);
       // print(downloadLink);

      //});

//now try can you try
//      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
//      StorageUploadTask uploadTask = reference.putFile(imageFile);
//      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
//      print(storageTaskSnapshot.totalByteCount);
//      prefs = await SharedPreferences.getInstance();
//      prefs.setString("loginUid", datenow);
//      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//        imageList.add(downloadUrl);
//      });
    //}

  }

  @override
  Widget build(BuildContext context) {
    TextStyle dataText = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
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
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical:10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "First Name",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      child: TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                        controller: firstnameController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
//                          contentPadding: new EdgeInsets.all(0.0),
//                          isDense: true,
                          hintText: username[0],
                          hintStyle:TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value){
                          username[0]=firstnameController.text;
                        },
                        onEditingComplete:(){
                          FocusScope. of (context). requestFocus (FocusNode ());
                          username[0]=firstnameController.text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Last Name",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      child: TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                        controller: lastnameController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
//                            contentPadding: new EdgeInsets.all(0.0),
//                            isDense: true,
                            hintText: username[1],
                            hintStyle:TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value){
                          username[1]=lastnameController.text;
                        },
                        onEditingComplete:(){
                          FocusScope. of (context). requestFocus (FocusNode ());
                          username[1]=lastnameController.text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal:0),
                      child: Text(
                        "Gender:",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio:4),
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 0,
                                groupValue: genderRadio,
                                onChanged: genderRadioValueChange),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  genderRadioValueChange(0);
                                },
                                child: Text(
                                  "Male",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                                value: 1,
                                groupValue: genderRadio,
                                onChanged: genderRadioValueChange),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  genderRadioValueChange(1);
                                },
                                child: Text(
                                  "Female",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Birthday",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: GestureDetector(
                        child: Text(
                          datatimes,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        onTap: (){
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2016, 3, 5),
                              maxTime: DateTime(2050, 6, 7), onChanged: (date) {
                                setState(() {
                                  datatimes = date.toString().split(" ")[0];
                                });
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  datatimes = date.toString().split(" ")[0];
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.en
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Nationaity",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            child: GestureDetector(
                              child: Text(
                                username[2],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return Nationaity();
                                }));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                        onPressed: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Nationaity();
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Detail Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detailltitle[0],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: educationTypeCtr,
                      decoration: InputDecoration(
                          hintText: detailltext[0]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            detailltitle[0],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(education[0]),
                              onPressed: () {
                                educationTypeCtr.text = education[0];
                                detailltext[0]=educationTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(education[1]),
                              onPressed: () {
                                educationTypeCtr.text = education[1];
                                detailltext[0]=educationTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(education[2]),
                              onPressed: () {
                                educationTypeCtr.text = education[2];
                                detailltext[0]=educationTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(education[3]),
                              onPressed: () {
                                educationTypeCtr.text = education[3];
                                detailltext[0]=educationTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detailltitle[1],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: religionTypeCtr,
                      decoration: InputDecoration(
                          hintText: detailltext[1]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            detailltitle[1],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(religion[0]),
                              onPressed: () {
                                religionTypeCtr.text = religion[0];
                                detailltext[1]=religionTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(religion[1]),
                              onPressed: () {
                                religionTypeCtr.text = religion[1];
                                detailltext[1]=religionTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(religion[2]),
                              onPressed: () {
                                religionTypeCtr.text = religion[2];
                                detailltext[1]=religionTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(religion[3]),
                              onPressed: () {
                                religionTypeCtr.text = religion[3];
                                detailltext[1]=religionTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detailltitle[2],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: maritalTypeCtr,
                      decoration: InputDecoration(
                          hintText: detailltext[2]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            detailltitle[2],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(marital[0]),
                              onPressed: () {
                                maritalTypeCtr.text = marital[0];
                                detailltext[2]=maritalTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(marital[1]),
                              onPressed: () {
                                maritalTypeCtr.text = marital[1];
                                detailltext[2]=maritalTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(marital[2]),
                              onPressed: () {
                                maritalTypeCtr.text = marital[2];
                                detailltext[2]=maritalTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(marital[3]),
                              onPressed: () {
                                maritalTypeCtr.text = marital[3];
                                detailltext[2]=maritalTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(marital[4]),
                              onPressed: () {
                                maritalTypeCtr.text = marital[4];
                                detailltext[2]=maritalTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detailltitle[3],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: childrenTypeCtr,
                      decoration: InputDecoration(
                          hintText: detailltext[3]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            detailltitle[3],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(children[0]),
                              onPressed: () {
                                childrenTypeCtr.text = children[0];
                                detailltext[3]=childrenTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(children[1]),
                              onPressed: () {
                                childrenTypeCtr.text = children[1];
                                detailltext[3]=childrenTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(children[2]),
                              onPressed: () {
                                childrenTypeCtr.text = children[2];
                                detailltext[3]=childrenTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(children[3]),
                              onPressed: () {
                                childrenTypeCtr.text =children[3];
                                detailltext[3]=childrenTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(children[4]),
                              onPressed: () {
                                childrenTypeCtr.text = children[4];
                                detailltext[3]=childrenTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            detailltitle[4],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                            child: GestureDetector(
                              child: Text(
                                detailltext[4],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return CurrentLocation();
                                }));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                        onPressed: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CurrentLocation();
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "WhatsApp",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      child: TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                        controller: whatsappController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
//                            contentPadding: new EdgeInsets.all(0.0),
//                            isDense: true,
                            hintText: whatapptext[0],
                            hintStyle:TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value){
                          whatapptext[0]=whatsappController.text;
                        },
                        onEditingComplete:(){
                          FocusScope. of (context). requestFocus (FocusNode ());
                          whatapptext[0]=whatsappController.text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Phone Number (verified)",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      child:TextFormField(
//                        scrollPadding:EdgeInsets.zero,
                        controller: phoneController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
//                            contentPadding: new EdgeInsets.all(0.0),
//                            isDense: true,
                            hintText: whatapptext[1],
                            hintStyle:TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value){
                          whatapptext[1]=phoneController.text;
                        },
                        onEditingComplete:(){
                          FocusScope. of (context). requestFocus (FocusNode ());
                          whatapptext[1]=phoneController.text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Work Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      worktop[0],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: jobtypeTypeCtr,
                      decoration: InputDecoration(
                          hintText: worktopdata[0]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            worktop[0],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(jobtype[0]),
                              onPressed: () {
                                jobtypeTypeCtr.text = jobtype[0];
                                worktopdata[0]=jobtypeTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(jobtype[1]),
                              onPressed: () {
                                jobtypeTypeCtr.text = jobtype[1];
                                worktopdata[0]=jobtypeTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      worktop[1],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: jobcapacityTypeCtr,
                      decoration: InputDecoration(
                          hintText: worktopdata[0]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            worktop[1],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(jobcapacity[0]),
                              onPressed: () {
                                jobcapacityTypeCtr.text = jobcapacity[0];
                                worktopdata[1]=jobcapacityTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(jobcapacity[1]),
                              onPressed: () {
                                jobcapacityTypeCtr.text = jobcapacity[1];
                                worktopdata[1]=jobcapacityTypeCtr.text;
                                Navigator.pop(context);
                              },
                            )
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      worktop[2],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    TextFormField(
                      style: dataText,
                      controller: contractTypeCtr,
                      decoration: InputDecoration(
                          hintText: worktopdata[0]),
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode());
                        final action = CupertinoActionSheet(
                          title: Text(
                            worktop[2],
                            style: TextStyle(fontSize: 30),
                          ),
                          message: Text(
                            "Select any option ",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(contract[0]),
                              onPressed: () {
                                contractTypeCtr.text = contract[0];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[1]),
                              onPressed: () {
                                contractTypeCtr.text = contract[1];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[2]),
                              onPressed: () {
                                contractTypeCtr.text = contract[2];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[3]),
                              onPressed: () {
                                contractTypeCtr.text = contract[3];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[4]),
                              onPressed: () {
                                contractTypeCtr.text = contract[4];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[5]),
                              onPressed: () {
                                contractTypeCtr.text = contract[5];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(contract[6]),
                              onPressed: () {
                                contractTypeCtr.text = contract[6];
                                worktopdata[2]=contractTypeCtr.text;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                          cancelButton:
                          CupertinoActionSheetAction(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) => action);
                      },
                    )
                  ],
                ),
              ),
            ),
            ListView.separated(
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
              itemCount: works.length,
              itemBuilder: (BuildContext context, int index) {
                Map workinfo = works[index];
                return Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              workinfo['title'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                              child: GestureDetector(
                                child: Text(
                                  workinfo['text'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: (){
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) {
                                    return workinfo['page'];
                                  }));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 18,
                          ),
                          onPressed: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return workinfo['page'];
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Work Experiences",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              worktexts[2],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            onTap: (){
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return WorkDate(workList: [],);
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 18,
                        ),
                        onPressed: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return WorkDate(workList: [],);
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      workend[0],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      child: TextFormField(
                        scrollPadding:EdgeInsets.zero,
                        controller: salaryController,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                            contentPadding: new EdgeInsets.all(0.0),
                            isDense: true,
                            hintText: worktexts[0],
                            hintStyle:TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            border: InputBorder.none
                        ),
                        onFieldSubmitted: (String value){
                          worktexts[0]=salaryController.text;
                        },
                        onEditingComplete:(){
                          FocusScope. of (context). requestFocus (FocusNode ());
                          worktexts[0]=salaryController.text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0.5,//宽度
                      color: Colors.grey[300] //边框颜色
                  ),
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      workend[1],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: GestureDetector(
                        child: Text(
                          worktexts[1],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        onTap: (){
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2016, 3, 5),
                              maxTime: DateTime(2050, 6, 7), onChanged: (date) {
                                setState(() {
                                  worktexts[1] = date.toString().split(" ")[0];
                                });
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  worktexts[1] = date.toString().split(" ")[0];
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.en
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Self Introduction',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: TextField(
                  controller: selfController,
                  maxLength: 500,
                  maxLines: 10,
                  autofocus: false,
                  textAlign: TextAlign.left,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Image Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child:Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  children: <Widget>[
                    imagesa.length !=0 ? buildGridView():Text(""),
                    Center(child: Text('Error: $_error')),
                    RaisedButton(
                      child: Text("Pick images"),
                      onPressed: loadAssets,
                    ),
                  ],
                ),
              ) ,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed:_submit,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color:Colors.pinkAccent,
                    child:Text(
                      'Sumbit',
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
          ],
        ),
      ),
    );
  }

  void genderRadioValueChange(int value) {
    setState(() {
      genderRadio = value;

      switch (genderRadio) {
        case 0:
          username[3] = "Male";
          break;
        case 1:
          username[3] = "Female";
          break;
      }
    });
  }
}

