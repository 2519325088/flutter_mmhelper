import 'package:after_init/after_init.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/Models/FacebookModel.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/MainPage.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/CountryListPopup.dart';
import 'widgets/platform_exception_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AfterInitMixin {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _firebaseAuth = FirebaseAuth.instance;
  String _message = '';
  String _verificationId;
  bool isShowSms = false;
  bool isLoading = false;
  bool isUserAvailable;
  Facebookdata facebookdata = Facebookdata();
  final _service = FirestoreService.instance;
  SharedPreferences prefs;
  QuerySnapshot querySnapshot;

  @override
  void didInitState() {
    getPhoneUserId().then((phoneUserId) {
      if (phoneUserId != null) {
        getUserPhone().then((phoneNumber) {
          getUserCCode().then((userCCode) async {
            querySnapshot = await Firestore.instance
                .collection("mb_content")
                .where("phone", isEqualTo: _phoneNumberController.text)
                .getDocuments();
            if (querySnapshot.documents.length == 0) {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                    return SignUpScreen(
                      mobileUserId: phoneUserId,
                      mobileNumber: phoneNumber,
                      countryCode: userCCode,
                    );
                  }), (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                    return MainPage(
                      mobileNo: phoneNumber,
                      isFromLogin: true,
                    );
                  }), (Route<dynamic> route) => false);
            }
          });
        });
      } else {
        var getCountryList = Provider.of<GetCountryListService>(context);
        getCountryList.getCountryList();
        getCountryList.newLoginCountry(
            newCountry: "Hong Kong", newCountryCode: "+852");
        _phoneNumberController.text = "96527733";
      }
    });
  }

  Future<String> getPhoneUserId() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("PhoneUserId");
  }

  Future<String> getUserPhone() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserPhone");
  }

  Future<String> getUserCCode() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("countrycode");
  }

  void _verifyPhoneNumber() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    if (getCountryList.selectedLoginCountryCode == "Select Code") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_select_dial_code')),
      ));
    } else if (_phoneNumberController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
        Text(AppLocalizations.of(context).translate('Please_enter_mobile')),
      ));
    } else {
      setState(() {
        _message = '';
      });
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential phoneAuthCredential) {
        _firebaseAuth.signInWithCredential(phoneAuthCredential);
        setState(() {
          _message = 'Received phone auth credential: $phoneAuthCredential';
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_message),
        ));
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        setState(() {
          _message =
          'Phone number verification failed. Code: ${authException
              .code}. Message: ${authException.message}';
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_message),
        ));
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Please_check_your_phone_for_the_verification_code')),
        ));
        setState(() {
          isShowSms = true;
        });
        _verificationId = verificationId;
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        _verificationId = verificationId;
      };

      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber:
          "${getCountryList.selectedLoginCountryCode}${_phoneNumberController
              .text}",
          timeout: const Duration(minutes: 1),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void _signInWithPhoneNumber() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    if (_smsController.text != "") {
      print("sms");
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      try {
        print(_smsController.text);
        final FirebaseUser user =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        final FirebaseUser currentUser = await _firebaseAuth.currentUser();
        assert(user.uid == currentUser.uid);

        if (user != null) {
          prefs = await SharedPreferences.getInstance();
          prefs.setString("PhoneUserId", user.uid);
          prefs.setString("UserPhone", _phoneNumberController.text);
          prefs.setString(
              "countrycode", getCountryList.selectedLoginCountryCode);
          _message = 'Successfully signed in, uid: ' + user.uid;
          if (isUserAvailable == true) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
                  return MainPage(
                    mobileNo: _phoneNumberController.text,
                    isFromLogin: true,
                  );
                }), (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
                  return SignUpScreen(
                    mobileUserId: user.uid,
                    mobileNumber: _phoneNumberController.text,
                    countryCode: "${getCountryList.selectedLoginCountryCode}",
                  );
                }), (Route<dynamic> route) => false);
          }
          /*final Contents = await database
              .flContentsStream()
              .first;
          final allPhone = Contents.map((contents) => contents.phone).toList();
          if (allPhone.contains(_phoneNumberController.text)){
            final Contents = await database
                .flContentsStream()
                .first;
            final id = Contents.map((contents) => contents.id).toList();
            print(id);
          }*/

        } else {
          _message = 'Sign in failed';
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
            AppLocalizations.of(context).translate('Please_enter_SMS_code')),
      ));
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final database = Provider.of<FirestoreDatabase>(context);
    final facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(
      ['email'],
    );

    if (result.status == FacebookLoginStatus.loggedIn) {
      if (result.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token,
          ),
        );

        database
            .facebookCall(scaffoldKey, result.accessToken.token)
            .then((onValue) async {
          //final emails = await database.flContentsStream().first;
          //final allemail = emails.map((job) => job.email).toList();
          /*if (allemail.contains(onValue.email)) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Dashboard(
                isFromLogin: true,
              );
            }), (Route<dynamic> route) => false);
          } else {
            final flContent = FlContent(
              name: onValue.name ?? "",
              email: onValue.email ?? "",
            );
            await database.createUser(flContent);
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return Dashboard(
                isFromLogin: true,
              );
            }), (Route<dynamic> route) => false);
          }*/
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return MainPage(
                  isFromLogin: true,
                );
              }), (Route<dynamic> route) => false);
        });

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(result.status.toString()),
      ));
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  Color gradientStart = Color(0xffbf9b30); //Change start gradient color here
  Color gradientEnd = Color(0xffe7d981); //Change end gradient color here

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          "assets/logo1.png",
                          height: 300,
                          width: 300,
                        )),
                    /* Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Login",
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StateListPopup(
                                isFromLogin: true,
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
                                getCountryList.selectedLoginCountry,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
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
                                          isFromLogin: true,
                                          isFromProfile: false,
                                        );
                                      });
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black.withOpacity(0.3)),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                                                .selectedLoginCountryCode,
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
                        ),
                        Expanded(
                          child: Padding(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType:
                                      TextInputType.numberWithOptions(
                                          signed: false, decimal: false),
                                      cursorColor:
                                      Theme
                                          .of(context)
                                          .accentColor,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.call),
                                          hintText: AppLocalizations.of(context)
                                              .translate('MobileNumber'),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    isShowSms
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black
                                            .withOpacity(0.3)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  child: TextFormField(
                                    controller: _smsController,
                                    keyboardType:
                                    TextInputType.numberWithOptions(
                                        signed: false,
                                        decimal: false),
                                    cursorColor:
                                    Theme
                                        .of(context)
                                        .accentColor,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.sms),
                                        hintText: AppLocalizations.of(
                                            context)
                                            .translate('Enter_SMS_code'),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _verifyPhoneNumber();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Not_received_Resend_SMS'),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: FlatButton(
                          onPressed: () async {
                            querySnapshot = await Firestore.instance
                                .collection("mb_content")
                                .where("phone",
                                isEqualTo: _phoneNumberController.text)
                                .getDocuments();
                            print(querySnapshot.documents);
                            if (querySnapshot.documents.length == 0) {
                              isUserAvailable = false;
                              if (isShowSms) {
                                _signInWithPhoneNumber();
                              } else {
                                _verifyPhoneNumber();
                              }
                            } else {
                              isUserAvailable = true;
                              if (isShowSms) {
                                _signInWithPhoneNumber();
                              } else {
                                _verifyPhoneNumber();
                              }
                            }
                          },
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                                child: Text(
                                  AppLocalizations.of(context).translate(
                                      'Submit'),
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              )),
                          shape: RoundedRectangleBorder(),
                          color: Colors.pink.withOpacity(0.7),
                        ),
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            }));
                          },
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 20),
                            child: Text(
                              AppLocalizations.of(context).translate('SignUp'),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                          shape: RoundedRectangleBorder(),
                          color: Colors.red,
                        ),
                      ),
                    ),*/
                  ],
                ),
                /*Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: FlatButton(
                                onPressed: () {
                                  signInWithFacebook();
                                },
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 20),
                                  child: Text(
                                    "Facebook",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                )),
                                shape: RoundedRectangleBorder(),
                                color: Colors.indigo,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) {
//                                  return MamaProfile();
                                    return MyJobProfilePage();
                                  }));
                                },
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 20),
                                  child: Text(
                                    "Profile",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                )),
                                shape: RoundedRectangleBorder(),
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          )),
    );
  }
}
