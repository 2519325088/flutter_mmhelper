import 'dart:io';

import 'package:after_init/after_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/MainPage.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/CountryListPopup.dart';
import 'widgets/platform_exception_alert_dialog.dart';

class User {
  User({@required this.uid});

  final String uid;
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();

  /// here you need to make constrictor
  /// here this variable pass from any page from you want to pass data we can
  /// also daclir default value
  SignUpScreen({this.mobileUserId, this.mobileNumber, this.countryCode});

  String mobileUserId, mobileNumber, countryCode;

  ///now we can use this data with widget.SignUpScreen
}

class _SignUpScreenState extends State<SignUpScreen> with AfterInitMixin {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  final _service = FirestoreService.instance;
  int genderRadio = -1;
  String genderSelectedValue = "";
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  File locProFileImage;
  String imageUrl;
  SharedPreferences prefs;
  List<Widget> roleWidget = [];
  String lastName;

  void _onSelectionChanged(String value) {
    roleController.text = value;

    ///here we got that selected data from role page
    ///now you understend?
    ///we cam
  }

//  this._SignUpScreenState.roleController.text = ${widget.roled}
  @override
  void didInitState() {
    var dataService = Provider.of<DataListService>(context);
    dataService.callListData(context);
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();
    // roleController.text = widget.dataFromOtherScreen;///like this/// you need to put
    roles.forEach((f) {
      roleWidget.add(
        CupertinoActionSheetAction(
          child: Text(f),
          onPressed: () {
            roleController.text = f;
            Navigator.pop(context);
          },
        ),
      );
    });
    mobileController.text = widget.mobileNumber;

    ///assign value in didInitState
  }

  Future uploadFile() async {
    final database = Provider.of<FirestoreDatabase>(context);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(locProFileImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.totalByteCount);
    prefs = await SharedPreferences.getInstance();
    prefs.setString("loginUid", database.lastUserId);
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      print(imageUrl);
      print("this is user id:${database.lastUserId}");
      if (imageUrl != null) {
        final flContent = FlContent(
          lastname: lastnameController.text ?? "",
          firstname: firstnameController.text ?? "",
          username: usernameController.text ?? "",
          role: roleController.text ?? "",
          gender: genderSelectedValue,
          email: emailController.text ?? "",
          phone: mobileController.text ?? "",
          password: "",
          //passwordController.text ?? "",
          nationality: nationalityController.text ?? "",
          religion: religionController.text ?? "",
          profileImageUrl: imageUrl,
          type: roleController.text ?? "",
          education: "",
          order: 0,
          parentId: 0,
          whatsApp: "",
          userId: widget.mobileUserId,
          countryCode: widget.countryCode,
        );
        _service
            .setData(
                path: APIPath.newCandidate(database.lastUserId),
                data: flContent.toMap())
            .then((onValue) async {
          prefs = await SharedPreferences.getInstance();
          prefs.setString("PhoneUserId", widget.mobileUserId);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return MainPage(
              isFromLogin: false,
              mobileNo: mobileController.text,
            );
          }), (Route<dynamic> route) => false);
        });
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Something_goes_wrong_to_upload_image')),
        ));
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate('This_file_is_not_an_image')),
      ));
    });
  }

  Future<void> _submit() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    final database = Provider.of<FirestoreDatabase>(context);
    if (locProFileImage == null) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate('Please_select_profile_Image')),
      ));
    } else if (mobileController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context).translate('Please_enter_mobile')),
      ));
    } else if (lastnameController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_lastname')),
      ));
    } else if (firstnameController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_firstname')),
      ));
    } else if (usernameController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_username')),
      ));
    } else if (roleController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context).translate('Please_enter_role')),
      ));
    } else if (emailController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context).translate('Please_enter_email')),
      ));
    }
    /*else if (passwordController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please enter password"),
      ));
    }*/
    else if (nationalityController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_nationality')),
      ));
    } else if (religionController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_religion')),
      ));
    } else if (genderRadio == -1) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_select_gender')),
      ));
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        final flContent = FlContent(
          lastname: lastnameController.text ?? "",
          firstname: firstnameController.text ?? "",
          username: usernameController.text ?? "",
          role: roleController.text ?? "",
          gender: genderSelectedValue,
          email: emailController.text ?? "",
          phone: mobileController.text ?? "",
          password: "",
          //passwordController.text ?? "",
          nationality: nationalityController.text ?? "",
          religion: religionController.text ?? "",
          type: roleController.text ?? "",
          education: "",
          order: 0,
          parentId: 0,
          whatsApp: "",
          userId: widget.mobileUserId,
          countryCode: widget.countryCode,
        );
        await database.createUser(flContent,widget.mobileUserId);
        uploadFile();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: AppLocalizations.of(context).translate('Operation_failed'),
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });
      PlatformExceptionAlertDialog(
        title: AppLocalizations.of(context).translate('Operation_failed'),
        exception: e,
      ).show(context);
      FocusScope.of(context).requestFocus(FocusNode());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  Future getImage(int imageSelect) async {
    final dir = await path_provider.getTemporaryDirectory();
    if (imageSelect == 1) {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        File imageFile = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg",
          quality: 50,
        );
        setState(() {
          locProFileImage = imageFile;
        });
      }
    } else if (imageSelect == 2) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg",
          quality: 50,
        );
        setState(() {
          locProFileImage = imageFile;
        });
      }
    }
  }

  _showItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: EdgeInsets.all(0.0),
        title: Container(
            color: Theme.of(context).accentColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                AppLocalizations.of(context).translate('Upload_Image'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    getImage(1);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                      ),
                      Text(AppLocalizations.of(context).translate('Camera')),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImage(2);
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.image,
                        size: 50,
                      ),
                      Text(AppLocalizations.of(context).translate('Gallery')),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('Cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('SignUp')),
        centerTitle: true,
        textTheme:
            TextTheme(title: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showItemDialog();
                        },
                        child: Align(
                            alignment: Alignment.center,
                            child: locProFileImage == null
                                ? CircleAvatar(
                                    radius: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_circle,
                                          size: 50,
                                        ),
                                        Text(AppLocalizations.of(context)
                                            .translate('Upload'))
                                      ],
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(locProFileImage),
                                  )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /*GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StateListPopup(
                                  isFromLogin: false,
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  getCountryList.selectedCountry,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.arrow_forward, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),*/
                      Row(
                        children: <Widget>[
                          /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StateListPopup(
                                            isFromLogin: false,
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              getCountryList
                                                  .selectedCountryCode,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: TextFormField(
                                          controller: mobileController,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: false, decimal: false),
                                          cursorColor:
                                              Theme.of(context).accentColor,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.call),
                                              hintText:
                                                  AppLocalizations.of(context)
                                                      .translate('MobileNumber'),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: lastnameController,
                                  onChanged: (data) {
                                    usernameController.text =
                                        data.toLowerCase();
                                    lastName = data.toLowerCase();
                                  },
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      hintText: AppLocalizations.of(context)
                                          .translate('LastName'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  onChanged: (data) {
                                    usernameController.text =
                                        lastName + data.toLowerCase();
                                  },
                                  controller: firstnameController,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      hintText: AppLocalizations.of(context)
                                          .translate('FirstName'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: usernameController,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      hintText: AppLocalizations.of(context)
                                          .translate('UserName'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: roleController,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle),
                                      hintText: AppLocalizations.of(context)
                                          .translate('Role'),
                                      border: InputBorder.none),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final action = CupertinoActionSheet(
                                      title: Text(
                                        AppLocalizations.of(context)
                                            .translate('Role'),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      message: Text(
                                        AppLocalizations.of(context)
                                            .translate('Select_any_option'),
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      actions: roleWidget,
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text(AppLocalizations.of(context)
                                            .translate('Cancel')),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => action);
                                    /*Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) {
                                      return RoleUser(onChanged: _onSelectionChanged,);
                                    }));*/
                                  },

                                  ///here i make one onchange function got back data from last page
                                  ///now try
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: emailController,
                                  cursorColor: Theme.of(context).accentColor,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      hintText: AppLocalizations.of(context)
                                          .translate('Email'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      hintText: "Password",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: nationalityController,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.flag),
                                      hintText: AppLocalizations.of(context)
                                          .translate('Nationality'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.3)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextFormField(
                                  controller: religionController,
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.supervised_user_circle),
                                      hintText: AppLocalizations.of(context)
                                          .translate('Religion'),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${AppLocalizations.of(context).translate('Gender')}:",
                                  style: TextStyle(fontSize: 16),
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
                                        crossAxisCount: 2, childAspectRatio: 4),
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
                                            AppLocalizations.of(context)
                                                .translate('Male'),
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
                                            AppLocalizations.of(context)
                                                .translate('Female'),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: FlatButton(
                            onPressed: _submit,
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('Register'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            )),
                            shape: RoundedRectangleBorder(),
                            color: Colors.pink.withOpacity(0.7),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                            ]),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
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
          genderSelectedValue = AppLocalizations.of(context).translate('Male');
          break;
        case 1:
          genderSelectedValue =
              AppLocalizations.of(context).translate('Female');
          break;
      }
    });
  }
}
