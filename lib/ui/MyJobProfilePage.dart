import 'package:after_init/after_init.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/api_path.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/AddWorkExperiencePage.dart';
import 'package:flutter_mmhelper/ui/QuestionPage.dart';
import 'package:flutter_mmhelper/ui/widgets/ChipsWidget.dart';
import 'package:flutter_mmhelper/ui/widgets/CountryListPopup.dart';
import 'package:flutter_mmhelper/ui/widgets/CupertinoActionSheetActionWidget.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyJobProfilePage extends StatefulWidget {
  @override
  _MyJobProfilePageState createState() => _MyJobProfilePageState();
  final String userId;
  QuerySnapshot loginUserData;
  ValueChanged<bool> valueChanged;

  MyJobProfilePage({this.userId, this.loginUserData, this.valueChanged});
}

class _MyJobProfilePageState extends State<MyJobProfilePage>
    with AfterInitMixin {
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController firstNameCtr = TextEditingController();
  TextEditingController facebookCtr = TextEditingController();
  TextEditingController lastNameCtr = TextEditingController();
  TextEditingController genderCtr = TextEditingController();
  TextEditingController birthDayCtr = TextEditingController();
  TextEditingController nationalityCtr = TextEditingController();
  TextEditingController eduCtr = TextEditingController();
  TextEditingController religionCtr = TextEditingController();
  TextEditingController maritalCtr = TextEditingController();
  TextEditingController childCtr = TextEditingController();
  TextEditingController locationCtr = TextEditingController();
  TextEditingController whatsAppCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController jobTypeCtr = TextEditingController();
  TextEditingController jobCapCtr = TextEditingController();
  TextEditingController contractCtr = TextEditingController();
  TextEditingController workingSkillCtr = TextEditingController();
  TextEditingController languageCtr = TextEditingController();
  TextEditingController expectedSalaryCtr = TextEditingController();
  TextEditingController startDateCtr = TextEditingController();
  TextEditingController selfCtr = TextEditingController();
  TextEditingController weightCtr = TextEditingController();
  TextEditingController heightCtr = TextEditingController();
  TextEditingController addressCtr = TextEditingController();
  TextEditingController userNameCtr = TextEditingController();
  DateTime startDate;
  DateTime birthDayDate;
  ProfileData profileData = ProfileData();

  List<Widget> eduWidget = [];
  List<Widget> religionWidget = [];
  List<Widget> maritalStatusWidget = [];
  List<Widget> childrenWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> jobCapWidget = [];
  List<Widget> contractWidget = [];
  List<Widget> workingSkillWidget = [];
  List<Widget> languageWidget = [];
  List<Widget> nationalityWidget = [];
  List<Widget> locationWidget = [];

  String languageCode;

  List<String> workingSkillStringList = [];
  List<String> languageStringList = [];

  List<DataList> listEducationData = [];
  List<DataList> listReligionData = [];
  List<DataList> listMaritalData = [];
  List<DataList> listChildrenData = [];
  List<DataList> listJobTypeData = [];
  List<DataList> listJobCapData = [];
  List<DataList> listContractData = [];
  List<DataList> listWorkSkillData = [];
  List<DataList> listLangData = [];
  List<DataList> listNationalityData = [];
  List<DataList> listLocationData = [];
  List<DataList> quitReasonData = [];
  List<DataList> quitReasonHkData = [];

  List<Asset> imagesa = List<Asset>();
  final _service = FirestoreService.instance;
  QuerySnapshot profileQuerySnapshot;
  ScrollController scrollController = ScrollController();
  bool isEdit = false;
  int exIndex;
  String countryCodeWhatApp = "+852";
  String countryCodePhone = "+852";

  onChangeCodeWhatsApp(String newCode) {
    setState(() {
      countryCodeWhatApp = newCode;
      profileData.countryCodeWhatsapp = newCode;
    });
  }

  onChangeCodePhone(String newCode) {
    setState(() {
      countryCodePhone = newCode;
      profileData.countryCodePhone = newCode;
    });
  }

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  Future<QuerySnapshot> getMyJobProfile() async {
    return await Firestore.instance
        .collection("mb_profile")
        .where("id", isEqualTo: widget.userId)
        .getDocuments();
  }

  @override
  void initState() {
    super.initState();

    profileData.imagelist = [];
    profileData.workexperiences = [];

    fetchLanguage().then((onValue) {
      languageCode = onValue;

      getMyJobProfile().then((onValue) {
        if (onValue.documents.length != 0) {
          profileData.updateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              TimeOfDay.now().hour,
              TimeOfDay.now().minute);
          profileData.approved = onValue.documents[0]["approved"];
          profileData.status = onValue.documents[0]["status"];

          profileData.createTime =
              (!onValue.documents[0].data.containsKey("create_time")) ||
                      (onValue.documents[0]["create_time"] == null) ||
                      (onValue.documents[0]["create_time"] == "")
                  ? null
                  : (onValue.documents[0]["create_time"] as Timestamp)
                      .toDate(); /* onValue.documents[0]["create_time"]??"";*/
          facebookCtr.text = onValue.documents[0]["facebook_id"];
          profileData.faceBookId = onValue.documents[0]["facebook_id"];

          weightCtr.text = onValue.documents[0]["weight"];
          profileData.weight = onValue.documents[0]["weight"];
          heightCtr.text = onValue.documents[0]["height"];
          profileData.height = onValue.documents[0]["height"];
          addressCtr.text = onValue.documents[0]["address"];
          profileData.address = onValue.documents[0]["address"];

          countryCodeWhatApp =
              onValue.documents[0]["countryCodeWhatsapp"] ?? null;
          profileData.countryCodeWhatsapp =
              onValue.documents[0]["countryCodeWhatsapp"] ?? null;

          countryCodePhone = onValue.documents[0]["countryCodePhone"] ?? null;
          profileData.countryCodePhone =
              onValue.documents[0]["countryCodePhone"] ?? null;
          firstNameCtr.text = onValue.documents[0]["firstname"];
          profileData.firstname = onValue.documents[0]["firstname"];

          userNameCtr.text = onValue.documents[0]["username"];
          profileData.userName = onValue.documents[0]["username"];

          lastNameCtr.text = onValue.documents[0]["lastname"];
          profileData.lastname = onValue.documents[0]["lastname"];
          genderCtr.text = onValue.documents[0]["gender"];
          profileData.gender = onValue.documents[0]["gender"];
          birthDayCtr.text = DateFormat.yMMMMEEEEd()
              .format(DateTime.parse(onValue.documents[0]["birthday"]));
          profileData.birthday =
              DateTime.parse(onValue.documents[0]["birthday"]);

          whatsAppCtr.text = onValue.documents[0]["whatsapp"];
          profileData.whatsapp = onValue.documents[0]["whatsapp"];
          phoneCtr.text = onValue.documents[0]["phone"];
          profileData.phone = onValue.documents[0]["phone"];

          expectedSalaryCtr.text = onValue.documents[0]["expectedsalary"];
          profileData.expectedsalary = onValue.documents[0]["expectedsalary"];
          startDateCtr.text = DateFormat.yMMMMEEEEd()
              .format(DateTime.parse(onValue.documents[0]["employment"]));
          profileData.employment =
              DateTime.parse(onValue.documents[0]["employment"]);
          selfCtr.text = onValue.documents[0]["selfintroduction"];
          profileData.selfintroduction =
              onValue.documents[0]["selfintroduction"];

          listWorkSkillData.forEach((f) {
            workingSkillWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: workingSkillStringList,
              isSelected: onValue.documents[0]["workskill"]
                  .toString()
                  .contains(f.nameId),
            ));
            workingSkillWidget.add(SizedBox(
              width: 5,
            ));
          });

          listLangData.forEach((f) {
            languageWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: languageStringList,
              isSelected: onValue.documents[0]["language"]
                  .toString()
                  .contains(f.nameId),
            ));
            languageWidget.add(SizedBox(
              width: 5,
            ));
          });

          listEducationData.forEach((f) {
            if (onValue.documents[0]["education"]
                .toString()
                .contains(f.nameId)) {
              eduCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.education = f.nameId;
            }
            eduWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  eduCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.education = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listReligionData.forEach((f) {
            if (onValue.documents[0]["religion"]
                .toString()
                .contains(f.nameId)) {
              religionCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.religion = f.nameId;
            }
            religionWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  religionCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.religion = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listMaritalData.forEach((f) {
            if (onValue.documents[0]["marital"].toString().contains(f.nameId)) {
              maritalCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.marital = f.nameId;
            }
            maritalStatusWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  maritalCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.marital = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listChildrenData.forEach((f) {
            if (onValue.documents[0]["children"]
                .toString()
                .contains(f.nameId)) {
              childCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.children = f.nameId;
            }
            childrenWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  childCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.children = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobTypeData.forEach((f) {
            if (onValue.documents[0]["jobtype"].toString().contains(f.nameId)) {
              jobTypeCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.jobtype = f.nameId;
            }
            jobTypeWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobTypeCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobtype = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobCapData.forEach((f) {
            if (onValue.documents[0]["jobcapacity"]
                .toString()
                .contains(f.nameId)) {
              jobCapCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.jobcapacity = f.nameId;
            }
            jobCapWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobCapCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobcapacity = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listContractData.forEach((f) {
            if (onValue.documents[0]["contract"]
                .toString()
                .contains(f.nameId)) {
              contractCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.contract = f.nameId;
            }
            /*contractWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  contractCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.contract = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );*/
          });

          listNationalityData.forEach((f) {
            if (onValue.documents[0]["nationaity"]
                .toString()
                .contains(f.nameId)) {
              nationalityCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.nationality = f.nameId;
            }
            nationalityWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  nationalityCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.nationality = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listLocationData.forEach((f) {
            if (onValue.documents[0]["current"].toString().contains(f.nameId)) {
              locationCtr.text = f.getValueByLanguageCode(languageCode);
              profileData.current = f.nameId;
              generateContract();
            }
            locationWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  generateContract();
                  locationCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.current = dataList.nameId;
                  print(dataList.nameId);
                  generateContract();
                  Navigator.pop(context);
                },
              ),
            );
          });

          if (profileData.current == "Hong Kong") {
            listContractData.forEach((f) {
              if (onValue.documents[0]["contract"]
                  .toString()
                  .contains(f.nameId)) {
                contractCtr.text = f.getValueByLanguageCode(languageCode);
                profileData.contract = f.nameId;
              }
            });
          } else {
            quitReasonData.forEach((f) {
              if (onValue.documents[0]["contract"]
                  .toString()
                  .contains(f.nameId)) {
                contractCtr.text = f.getValueByLanguageCode(languageCode);
                profileData.contract = f.nameId;
              }
            });
          }

          setState(() {});

          onValue.documents[0]["workexperiences"].forEach((f) {
            profileData.workexperiences.add(Workexperience.fromMap((f)));
          });
          onValue.documents[0]["imagelist"].forEach((f) {
            profileData.imagelist.add(f);
          });
          profileData.primaryImage = onValue.documents[0]["primaryimage"];
        } else {
          if (widget.loginUserData.documents.length != 0) {
            profileData.createTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                TimeOfDay.now().hour,
                TimeOfDay.now().minute);
            profileData.updateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                TimeOfDay.now().hour,
                TimeOfDay.now().minute);
            print(profileData.createTime);
            profileData.approved = "No";
//            profileData.status = "pending";
            profileData.status = "Created";
            userNameCtr.text = widget.loginUserData.documents[0]["username"];
            profileData.userName =
                widget.loginUserData.documents[0]["username"];
            firstNameCtr.text = widget.loginUserData.documents[0]["firstname"];
            profileData.firstname =
                widget.loginUserData.documents[0]["firstname"];

            lastNameCtr.text = widget.loginUserData.documents[0]["lastname"];
            profileData.lastname =
                widget.loginUserData.documents[0]["lastname"];

            genderCtr.text = widget.loginUserData.documents[0]["gender"];
            profileData.gender = widget.loginUserData.documents[0]["gender"];

            phoneCtr.text = widget.loginUserData.documents[0]["phone"];
            profileData.phone = widget.loginUserData.documents[0]["phone"];

            profileData.countryCodePhone = "+852";
            profileData.countryCodeWhatsapp = "+852";
            facebookCtr.text = widget.loginUserData.documents[0]["facebookId"];
            profileData.faceBookId =
                widget.loginUserData.documents[0]["facebookId"];
          }
          listWorkSkillData.forEach((f) {
            workingSkillWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: workingSkillStringList,
              isSelected: false,
            ));
            workingSkillWidget.add(SizedBox(
              width: 5,
            ));
          });

          listLangData.forEach((f) {
            languageWidget.add(ChipsWidget(
              languageCode: languageCode,
              dataList: f,
              typeStringList: languageStringList,
              isSelected: false,
            ));
            languageWidget.add(SizedBox(
              width: 5,
            ));
          });

          listEducationData.forEach((f) {
            eduWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  eduCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.education = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listReligionData.forEach((f) {
            if (widget.loginUserData.documents.length != 0) {
              if (widget.loginUserData.documents[0]["religion"]
                  .toString()
                  .contains(f.nameId)) {
                religionCtr.text = f.getValueByLanguageCode(languageCode);
                profileData.religion = f.nameId;
              }
            }
            religionWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  religionCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.religion = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listMaritalData.forEach((f) {
            maritalStatusWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  maritalCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.marital = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listChildrenData.forEach((f) {
            childrenWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  childCtr.text = dataList.getValueByLanguageCode(languageCode);
                  profileData.children = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobTypeData.forEach((f) {
            jobTypeWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobTypeCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobtype = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listJobCapData.forEach((f) {
            jobCapWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  jobCapCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.jobcapacity = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          /*listContractData.forEach((f) {
            contractWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  contractCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.contract = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });*/

          listNationalityData.forEach((f) {
            if (widget.loginUserData.documents.length != 0) {
              if (widget.loginUserData.documents[0]["nationality"]
                  .toString()
                  .contains(f.nameId)) {
                nationalityCtr.text = f.getValueByLanguageCode(languageCode);
                profileData.nationality = f.nameId;
              }
            }
            nationalityWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  nationalityCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.nationality = dataList.nameId;
                  print(dataList.nameId);
                  Navigator.pop(context);
                },
              ),
            );
          });

          listLocationData.forEach((f) {
            locationWidget.add(
              CupertinoActionSheetActionWidget(
                languageCode: languageCode,
                dataList: f,
                onPressedCall: (dataList) {
                  locationCtr.text =
                      dataList.getValueByLanguageCode(languageCode);
                  profileData.current = dataList.nameId;
                  print(dataList.nameId);
                  generateContract();
                  Navigator.pop(context);
                },
              ),
            );
          });
          setState(() {});
        }
        generateContract();
      });
    });
  }

  generateContract() {
    print("call generate");
    contractWidget = [];
    print("current location ------------------ ${profileData.current}");
    if (profileData.current == "Hong Kong") {
      listContractData.forEach((f) {
        contractWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              contractCtr.text = dataList.getValueByLanguageCode(languageCode);
              profileData.contract = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });
    } else {
      quitReasonData.forEach((f) {
        contractWidget.add(
          CupertinoActionSheetActionWidget(
            languageCode: languageCode,
            dataList: f,
            onPressedCall: (dataList) {
              contractCtr.text = dataList.getValueByLanguageCode(languageCode);
              profileData.contract = dataList.nameId;
              print(dataList.nameId);
              Navigator.pop(context);
            },
          ),
        );
      });
    }
  }

  onWorkingExChange(Workexperience workExperience) {
    if (isEdit == false) {
      setState(() {
        profileData.workexperiences.add(workExperience);
      });
    } else {
      setState(() {
        profileData.workexperiences.removeAt(exIndex);
        profileData.workexperiences.add(workExperience);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstNameCtr.dispose();
    facebookCtr.dispose();
    lastNameCtr.dispose();
    genderCtr.dispose();
    birthDayCtr.dispose();
    nationalityCtr.dispose();
    eduCtr.dispose();
    religionCtr.dispose();
    maritalCtr.dispose();
    childCtr.dispose();
    locationCtr.dispose();
    whatsAppCtr.dispose();
    phoneCtr.dispose();
    jobTypeCtr.dispose();
    jobCapCtr.dispose();
    contractCtr.dispose();
    workingSkillCtr.dispose();
    languageCtr.dispose();
    expectedSalaryCtr.dispose();
    startDateCtr.dispose();
    selfCtr.dispose();
    scrollController.dispose();
    weightCtr.dispose();
    heightCtr.dispose();
    addressCtr.dispose();
    userNameCtr.dispose();
  }

  uploadFirebaseImageData() async {
    int number = 0;
    do {
      String downloadLink = await saveImage(imagesa[number]);
      if (!profileData.imagelist.contains(downloadLink))
        profileData.imagelist.add(downloadLink);
      print("Upload in count $number");
      number++;
    } while (number < imagesa.length);
    saveProfileData();
  }

  saveProfileData() {
    print("Profile update call");
    if (profileData.primaryImage == null) {
      profileData.primaryImage = profileData.imagelist[0];
    }
    _service
        .setData(
            path: APIPath.newProfile(widget.userId), data: profileData.toMap())
        .then((onValue) {
      widget.valueChanged(true);
      setState(() {
        isLoading = false;
        imagesa.clear();
      });
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .translate('Profile_Update_Successfully'),
          ),
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return QuestionPage(
          skill: profileData.workskill,
          profileid: profileData.id,
        );
      }));
    });
  }

  //  sumbit image
  Future<String> saveImage(Asset asset) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.totalByteCount);
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  Future<List<int>> testCompressAsset(String assetName) async {
    var list = await FlutterImageCompress.compressAssetImage(
      assetName,
      quality: 20,
    );
    return list;
  }

  Future<List<String>> uploadImage({@required List<Asset> assets}) async {
    List<String> uploadUrls = [];

    await Future.wait(
        assets.map((Asset asset) async {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          //ByteData byteData = await asset.getByteData();
          List<int> imageData =await testCompressAsset(asset.name);
          print("assets name:${asset.name}");
          StorageReference reference =
              FirebaseStorage.instance.ref().child(fileName);
          StorageUploadTask uploadTask = reference.putData(imageData);
          StorageTaskSnapshot storageTaskSnapshot;

          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls.add(downloadUrl);

            print('Upload success');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });

    return uploadUrls;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cardTitleText = TextStyle(fontSize: 20, color: Colors.black);
    TextStyle titleText =
        TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7));
    TextStyle dataText = TextStyle(fontSize: 20);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('My_Job_Profile')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                if (isLoading == false) {
                  if (userNameCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_username'))));
                  } else if (firstNameCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_firstname'))));
                  } else if (lastNameCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_lastname'))));
                  } else if (genderCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_gender'))));
                  } else if (birthDayCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_birth_date'))));
                  } else if (nationalityCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_nationality'))));
                  } else if (eduCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_education'))));
                  } else if (religionCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_religion'))));
                  } else if (maritalCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_marital_status'))));
                  } else if (childCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_child'))));
                  } else if (locationCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_location'))));
                  } else if (countryCodeWhatApp == null) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_whatsapp_number_code'))));
                  } else if (whatsAppCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_whatsapp_number'))));
                  } else if (countryCodePhone == null) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_phone_code'))));
                  } else if (phoneCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_phone'))));
                  } else if (jobTypeCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_job_type'))));
                  } else if (jobCapCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_job_capacity'))));
                  } else if (contractCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_contract'))));
                  } else if (workingSkillStringList.length == 0) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_working_skill'))));
                  } else if (languageStringList.length == 0) {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_select_language'))));
                  } else if (expectedSalaryCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_expected_salary'))));
                  } else if (startDateCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context).translate(
                            'Please_select_employement_start_date'))));
                  } else if (selfCtr.text == "") {
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('Please_enter_self_introduction'))));
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    String workingSkillString = "";
                    String languageString = "";
                    workingSkillStringList.forEach((f) {
                      workingSkillString += "$f;";
                    });
                    languageStringList.forEach((f) {
                      languageString += "$f;";
                    });
                    print("Upload education ${profileData.education}");
                    profileData.workskill = workingSkillString;
                    profileData.language = languageString;
                    profileData.id = widget.userId;
                    int i = 1;

                    if (imagesa.length != 0) {
                      uploadFirebaseImageData();
                    } else {
                      if (profileData.imagelist.length != 0) {
                        _service
                            .setData(
                                path: APIPath.newProfile(widget.userId),
                                data: profileData.toMap())
                            .then((onValue) {
                          widget.valueChanged(true);
                          setState(() {
                            isLoading = false;
                            imagesa.clear();
                          });
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .translate('Profile_Update_Successfully'))));
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return QuestionPage(
                              skill: profileData.workskill,
                              profileid: profileData.id,
                            );
                          }));
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(AppLocalizations.of(context)
                                .translate('Please_select_Image'))));
                      }
                    }
                  }
                } else {
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate('Wait_data_is_updating'))));
                }
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Basic_Information'),
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('UserName')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.userName = newValue;
                                            },
                                            controller: userNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate('UserName')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('FirstName')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.firstname = newValue;
                                            },
                                            controller: firstNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_first_name')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('LastName')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.lastname = newValue;
                                            },
                                            controller: lastNameCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Enter_last_name')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Gender')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: genderCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Gender')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Gender'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate('Male')),
                                                    onPressed: () {
                                                      genderCtr.text =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Male');
                                                      profileData.gender =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Male');
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text(AppLocalizations
                                                            .of(context)
                                                        .translate('Female')),
                                                    onPressed: () {
                                                      genderCtr.text =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Female');
                                                      profileData.gender =
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'Female');
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('weight')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.weight = newValue;
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: true),
                                            controller: weightCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate('weight'),
                                                suffixText:
                                                    AppLocalizations.of(context)
                                                        .translate('kg')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('height')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.height = newValue;
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: true),
                                            controller: heightCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate('height'),
                                                suffixText:
                                                    AppLocalizations.of(context)
                                                        .translate('cm')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Birthday')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(1950, 1, 1),
                                                  maxTime: DateTime.now(),
                                                  /* onChanged: (date) {
                                                    setState(() {
                                                      birthDayDate = date;
                                                    });
                                                    birthDayCtr.text = DateFormat.yMMMMEEEEd().format(birthDayDate);
                                                    profileData.birthday = birthDayDate;
                                                  },*/
                                                  onConfirm: (date) {
                                                setState(() {
                                                  birthDayDate = date;
                                                });
                                                birthDayCtr.text =
                                                    DateFormat.yMMMMEEEEd()
                                                        .format(birthDayDate);
                                                profileData.birthday =
                                                    birthDayDate;
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                            },
                                            controller: birthDayCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Birthday')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Nationality')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: nationalityCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Nationality')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Nationality'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: nationalityWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Detail_Information'),
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Education')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: eduCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Education')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Education'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: eduWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Religion')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: religionCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Religion')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Religion'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: religionWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Marital_Status')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: maritalCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Marital_Status')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Marital_Status'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: maritalStatusWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Children')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: childCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Children')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Children'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: childrenWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Current_Location')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: locationCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Current_Location')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Current_Location'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: locationWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Whatsapp_Number')}:",
                                            style: titleText,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StateListPopup(
                                                                isFromLogin:
                                                                    false,
                                                                isFromWorkProfile:
                                                                    false,
                                                                isFromProfile:
                                                                    true,
                                                                onChangedCode:
                                                                    onChangeCodeWhatsApp,
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                        width:
                                                                            0.5)),
                                                            color:
                                                                Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  countryCodeWhatApp ??
                                                                      "Code",
                                                                  style:
                                                                      dataText,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              Icon(Icons
                                                                  .keyboard_arrow_down)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  onChanged: (newText) {
                                                    profileData.whatsapp =
                                                        "$newText";
                                                  },
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        15),
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly,
                                                    BlacklistingTextInputFormatter
                                                        .singleLineFormatter,
                                                  ],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          signed: false,
                                                          decimal: false),
                                                  controller: whatsAppCtr,
                                                  style: dataText,
                                                  decoration: InputDecoration(
                                                      hintText: AppLocalizations
                                                              .of(context)
                                                          .translate(
                                                              'Enter_whatsapp_number')),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone_android,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Phone_Number_verified')}:",
                                            style: titleText,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StateListPopup(
                                                                isFromLogin:
                                                                    false,
                                                                isFromWorkProfile:
                                                                    false,
                                                                isFromProfile2:
                                                                    true,
                                                                isFromProfile:
                                                                    false,
                                                                onChangedCode2:
                                                                    onChangeCodePhone,
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom:
                                                                    BorderSide(
                                                                        width:
                                                                            0.5)),
                                                            color:
                                                                Colors.white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  countryCodePhone ??
                                                                      "Code",
                                                                  style:
                                                                      dataText,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              Icon(Icons
                                                                  .keyboard_arrow_down)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  onChanged: (newText) {
                                                    profileData.phone =
                                                        "$newText";
                                                  },
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        15),
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly,
                                                    BlacklistingTextInputFormatter
                                                        .singleLineFormatter,
                                                  ],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          signed: false,
                                                          decimal: false),
                                                  controller: phoneCtr,
                                                  style: dataText,
                                                  decoration: InputDecoration(
                                                      hintText: AppLocalizations
                                                              .of(context)
                                                          .translate(
                                                              'Enter_Phone_number')),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('address')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.address = newValue;
                                            },
                                            controller: addressCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate('address')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('FacebookId')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.faceBookId = newValue;
                                            },
                                            controller: facebookCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Enter_facebook')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Work_Information'),
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Job_Type')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobTypeCtr,
                                            decoration: InputDecoration(
                                                hintText:
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Select_Job_Type')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('Job_Type'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobTypeWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Job_Capacity')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: jobCapCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Job_Capacity')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Job_Capacity'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: jobCapWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Contract_Status')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            style: dataText,
                                            controller: contractCtr,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Select_Contract_Status')),
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              final action =
                                                  CupertinoActionSheet(
                                                title: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Contract_Status'),
                                                  style:
                                                      TextStyle(fontSize: 30),
                                                ),
                                                message: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'Select_any_option'),
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                ),
                                                actions: contractWidget,
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate('Cancel')),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.dashboard,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Working_Skill')}:",
                                            style: titleText,
                                          ),
                                          Wrap(children: workingSkillWidget)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Language')}:",
                                            style: titleText,
                                          ),
                                          Wrap(children: languageWidget)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Expected_Salary_HKD')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onChanged: (newValue) {
                                              profileData.expectedsalary =
                                                  newValue;
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  15),
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                              BlacklistingTextInputFormatter
                                                  .singleLineFormatter,
                                            ],
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    signed: false,
                                                    decimal: false),
                                            controller: expectedSalaryCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'Enter_expected_salary')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black54,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${AppLocalizations.of(context).translate('Employement_Start_Date')}:",
                                            style: titleText,
                                          ),
                                          TextFormField(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime.now(),
                                                  maxTime:
                                                      DateTime(2030, 12, 31),
                                                  onConfirm: (date) {
                                                setState(() {
                                                  startDate = date;
                                                });
                                                startDateCtr.text =
                                                    DateFormat.yMMMMEEEEd()
                                                        .format(startDate);
                                                profileData.employment =
                                                    startDate;
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                            },
                                            controller: startDateCtr,
                                            style: dataText,
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate('Select_Date')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('Work_Experience'),
                                      style: cardTitleText,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          isEdit = false;
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddWorkExperiencePage(
                                              onChanged: onWorkingExChange,
                                              currentLoc: profileData.current,
                                              oldWorkExperience: null,
                                            );
                                          }));
                                        },
                                        child: Icon(Icons.add)),
                                  ],
                                ),
                              )),
                          profileData.workexperiences.length != 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: profileData.workexperiences.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      onTap: () {
                                        isEdit = true;
                                        exIndex = index;
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AddWorkExperiencePage(
                                            onChanged: onWorkingExChange,
                                            currentLoc: profileData.current,
                                            oldWorkExperience: profileData
                                                .workexperiences[index],
                                          );
                                        }));
                                      },
                                      title: Text(
                                        "Working experience#${index + 1}",
//                                        profileData
//                                            .workexperiences[index].jobtype,
                                        style: titleText,
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () {
                                            setState(() {
                                              profileData.workexperiences
                                                  .removeAt(index);
                                            });
                                          }),
                                    );
                                  })
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('Add_your_work_experince'),
                                    style: titleText,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Self_Introduction'),
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  onChanged: (newValue) {
                                    profileData.selfintroduction = newValue;
                                  },
                                  maxLines: 5,
                                  controller: selfCtr,
                                  style: dataText,
                                  decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate(
                                              'Enter_self_introduction')),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.black.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('Image_Introduction'),
                                  style: cardTitleText,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      profileData.primaryImage != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Primary_Image'),
                                                    style: titleText,
                                                  ),
                                                ),
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      profileData.primaryImage,
                                                  height: 110,
                                                  width: 110,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                              ],
                                            )
                                          : SizedBox(),
                                      profileData.imagelist.length != 0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Server_Image'),
                                                    style: titleText,
                                                  ),
                                                ),
                                                profileData.imagelist.length !=
                                                        0
                                                    ? editBuildGridView()
                                                    : SizedBox(),
                                              ],
                                            )
                                          : SizedBox(),
                                      imagesa.length != 0
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'Local_Image'),
                                                    style: titleText,
                                                  ),
                                                ),
                                                imagesa.length != 0
                                                    ? buildGridView()
                                                    : Text(""),
                                              ],
                                            )
                                          : SizedBox(),
                                      Align(
                                        alignment: Alignment.center,
                                        child: RaisedButton(
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('Pick_images')),
                                          onPressed: loadAssets,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: isLoading
                  ? Container(
                      color: Colors.black45,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox())
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
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

  Widget editBuildGridView() {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: List.generate(profileData.imagelist.length, (index) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  profileData.primaryImage = profileData.imagelist[index];
                });
              },
              child: CachedNetworkImage(
                imageUrl: profileData.imagelist[index],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      profileData.imagelist.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.black45,
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
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
    });
  }

  Future<void> selectBirthDayDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 21900)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDayDate = picked;
        birthDayCtr.text = DateFormat.yMMMMEEEEd().format(birthDayDate);
        profileData.birthday = birthDayDate;
      });
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        startDateCtr.text = DateFormat.yMMMMEEEEd().format(startDate);
        profileData.employment = startDate;
      });
    }
  }

  @override
  void didInitState() {
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();

    var appLanguage = Provider.of<DataListService>(context);
    listEducationData = appLanguage.listEducationData;
    listReligionData = appLanguage.listReligionData;
    listMaritalData = appLanguage.listMaritalData;
    listChildrenData = appLanguage.listChildrenData;
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listJobCapData = appLanguage.listJobCapData;
    listWorkSkillData = appLanguage.listWorkSkillData;
    listLangData = appLanguage.listLangData;
    listNationalityData = appLanguage.listNationalityData;
    listLocationData = appLanguage.listLocationData;
    quitReasonData = appLanguage.listQuitReasonData;
    quitReasonHkData = appLanguage.listQuitReasonHkData;
  }
}
