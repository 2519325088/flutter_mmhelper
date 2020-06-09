import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
  DocumentSnapshot myProfileDocumentSnapshot;

  MyProfilePage({this.myProfileDocumentSnapshot});
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController firstNameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController mobileCtr = TextEditingController();
  TextEditingController userNameCtr = TextEditingController();
  TextEditingController lastNameCtr = TextEditingController();

  File locProFileImage;
  String imageUrl;
  final _service = FirestoreService.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  QuerySnapshot querySnapshot;
  String userType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameCtr.text = widget.myProfileDocumentSnapshot["username"];
    firstNameCtr.text = widget.myProfileDocumentSnapshot["firstname"];
    lastNameCtr.text = widget.myProfileDocumentSnapshot["lastname"];
    mobileCtr.text = widget.myProfileDocumentSnapshot["phone"];
    emailCtr.text = widget.myProfileDocumentSnapshot["email"];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    firstNameCtr.dispose();
    mobileCtr.dispose();
    emailCtr.dispose();
    userNameCtr.dispose();
    lastNameCtr.dispose();
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

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    querySnapshot = await Firestore.instance
        .collection("mb_content")
        .where("phone", isEqualTo: mobileCtr.text)
        .getDocuments();
    print(querySnapshot.documents);
    if (querySnapshot.documents.length == 0) {
      if (locProFileImage != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference reference =
            FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = reference.putFile(locProFileImage);
        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        print(storageTaskSnapshot.totalByteCount);
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          imageUrl = downloadUrl;
          print(imageUrl);
          if (imageUrl != null) {
            final flContent = FlContent(
              lastname: lastNameCtr.text ?? "",
              firstname: firstNameCtr.text ?? "",
              username: userNameCtr.text ?? "",
              role: widget.myProfileDocumentSnapshot["role"],
              gender: widget.myProfileDocumentSnapshot["gender"],
              email: widget.myProfileDocumentSnapshot["email"],
              phone: widget.myProfileDocumentSnapshot["phone"],
              password: widget.myProfileDocumentSnapshot["password"],
              nationality: widget.myProfileDocumentSnapshot["nationality"],
              religion: widget.myProfileDocumentSnapshot["religion"],
              profileImageUrl: locProFileImage != null
                  ? imageUrl
                  : widget.myProfileDocumentSnapshot["profileImageUrl"],
              type: widget.myProfileDocumentSnapshot["type"],
              education: widget.myProfileDocumentSnapshot["education"],
              order: widget.myProfileDocumentSnapshot["order"],
              parentId: widget.myProfileDocumentSnapshot["parentId"],
              whatsApp: widget.myProfileDocumentSnapshot["whatsApp"],
              userId: widget.myProfileDocumentSnapshot["userId"],
            );
            _service.setData(
                path: APIPath.newCandidate(
                    widget.myProfileDocumentSnapshot["userId"]),
                data: flContent.toMap());
            Navigator.pop(context);
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
      } else {
        final flContent = FlContent(
          lastname: lastNameCtr.text ?? "",
          firstname: firstNameCtr.text ?? "",
          username: userNameCtr.text ?? "",
          role: widget.myProfileDocumentSnapshot["role"],
          gender: widget.myProfileDocumentSnapshot["gender"],
          email: widget.myProfileDocumentSnapshot["email"],
          phone: widget.myProfileDocumentSnapshot["phone"],
          password: widget.myProfileDocumentSnapshot["password"],
          nationality: widget.myProfileDocumentSnapshot["nationality"],
          religion: widget.myProfileDocumentSnapshot["religion"],
          profileImageUrl: widget.myProfileDocumentSnapshot["profileImageUrl"],
          type: widget.myProfileDocumentSnapshot["type"],
          education: widget.myProfileDocumentSnapshot["education"],
          order: widget.myProfileDocumentSnapshot["order"],
          parentId: widget.myProfileDocumentSnapshot["parentId"],
          whatsApp: widget.myProfileDocumentSnapshot["whatsApp"],
          userId: widget.myProfileDocumentSnapshot["userId"],
        );

        _service.setData(
            path: APIPath.newCandidate(
                widget.myProfileDocumentSnapshot["userId"]),
            data: flContent.toMap());
        Navigator.pop(context);
      }
    } else {
      if (widget.myProfileDocumentSnapshot["phone"] == mobileCtr.text) {
        if (locProFileImage != null) {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          StorageReference reference =
              FirebaseStorage.instance.ref().child(fileName);
          StorageUploadTask uploadTask = reference.putFile(locProFileImage);
          StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
          print(storageTaskSnapshot.totalByteCount);
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            imageUrl = downloadUrl;
            print(imageUrl);
            if (imageUrl != null) {
              final flContent = FlContent(
                lastname: lastNameCtr.text ?? "",
                firstname: firstNameCtr.text ?? "",
                username: userNameCtr.text ?? "",
                role: widget.myProfileDocumentSnapshot["role"],
                gender: widget.myProfileDocumentSnapshot["gender"],
                email: widget.myProfileDocumentSnapshot["email"],
                phone: widget.myProfileDocumentSnapshot["phone"],
                password: widget.myProfileDocumentSnapshot["password"],
                nationality: widget.myProfileDocumentSnapshot["nationality"],
                religion: widget.myProfileDocumentSnapshot["religion"],
                profileImageUrl: locProFileImage != null
                    ? imageUrl
                    : widget.myProfileDocumentSnapshot["profileImageUrl"],
                type: widget.myProfileDocumentSnapshot["type"],
                education: widget.myProfileDocumentSnapshot["education"],
                order: widget.myProfileDocumentSnapshot["order"],
                parentId: widget.myProfileDocumentSnapshot["parentId"],
                whatsApp: widget.myProfileDocumentSnapshot["whatsApp"],
                userId: widget.myProfileDocumentSnapshot["userId"],
              );
              _service.setData(
                  path: APIPath.newCandidate(
                      widget.myProfileDocumentSnapshot["userId"]),
                  data: flContent.toMap());
              Navigator.pop(context);
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
        } else {
          final flContent = FlContent(
            lastname: lastNameCtr.text ?? "",
            firstname: firstNameCtr.text ?? "",
            username: userNameCtr.text ?? "",
            role: widget.myProfileDocumentSnapshot["role"],
            gender: widget.myProfileDocumentSnapshot["gender"],
            email: widget.myProfileDocumentSnapshot["email"],
            phone: widget.myProfileDocumentSnapshot["phone"],
            password: widget.myProfileDocumentSnapshot["password"],
            nationality: widget.myProfileDocumentSnapshot["nationality"],
            religion: widget.myProfileDocumentSnapshot["religion"],
            profileImageUrl:
                widget.myProfileDocumentSnapshot["profileImageUrl"],
            type: widget.myProfileDocumentSnapshot["type"],
            education: widget.myProfileDocumentSnapshot["education"],
            order: widget.myProfileDocumentSnapshot["order"],
            parentId: widget.myProfileDocumentSnapshot["parentId"],
            whatsApp: widget.myProfileDocumentSnapshot["whatsApp"],
            userId: widget.myProfileDocumentSnapshot["userId"],
          );

          _service.setData(
              path: APIPath.newCandidate(
                  widget.myProfileDocumentSnapshot["userId"]),
              data: flContent.toMap());
          Navigator.pop(context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('Mobile_Number_already_register'))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleText = TextStyle(
        fontSize: 18,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.bold);
    TextStyle dataText = TextStyle(fontSize: 18);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('My_Profile')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                uploadFile();
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
              child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showItemDialog();
                    },
                    child: Card(
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                            "assets/placeholder.jpg",
                                          )),
                                  imageUrl: widget.myProfileDocumentSnapshot[
                                          "profileImageUrl"] ??
                                      "",
                                  fit: BoxFit.cover,
                                  imageBuilder: (BuildContext context, image) {
                                    return CircleAvatar(
                                      radius: 40,
                                      backgroundImage: locProFileImage == null
                                          ? image
                                          : FileImage(locProFileImage),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.border_color,
                                        size: 15,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          IgnorePointer(
                            ignoring: true,
                            child: jobDataField(
                                titleText: titleText,
                                dataText: dataText,
                                title: AppLocalizations.of(context)
                                    .translate('UserName'),
                                filedCtr: userNameCtr,
                                icons: Icons.perm_contact_calendar,
                                maxLine: 1),
                          ),
                          jobDataField(
                              titleText: titleText,
                              dataText: dataText,
                              title: AppLocalizations.of(context)
                                  .translate('FirstName'),
                              filedCtr: firstNameCtr,
                              icons: Icons.perm_contact_calendar,
                              maxLine: 1),
                          jobDataField(
                              titleText: titleText,
                              dataText: dataText,
                              title: AppLocalizations.of(context)
                                  .translate('LastName'),
                              filedCtr: lastNameCtr,
                              icons: Icons.perm_contact_calendar,
                              maxLine: 1),
                          IgnorePointer(
                            ignoring: true,
                            child: jobDataField(
                                titleText: titleText,
                                dataText: dataText,
                                title: AppLocalizations.of(context)
                                    .translate('Email'),
                                filedCtr: emailCtr,
                                icons: Icons.email,
                                maxLine: 1),
                          ),
                          jobDataField(
                              titleText: titleText,
                              dataText: dataText,
                              title: AppLocalizations.of(context)
                                  .translate('Mobile'),
                              filedCtr: mobileCtr,
                              icons: Icons.phone_android,
                              maxLine: 1),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
          Positioned.fill(
              child: isLoading
                  ? Container(
                      color: Colors.white.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }

  Widget jobDataField(
      {String title,
      TextStyle titleText,
      TextStyle dataText,
      TextEditingController filedCtr,
      IconData icons,
      int maxLine}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icons,
            color: Colors.black54,
            size: 25,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$title:",
                  style: titleText,
                ),
                TextFormField(
                  maxLines: maxLine,
                  style: dataText,
                  controller: filedCtr,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
