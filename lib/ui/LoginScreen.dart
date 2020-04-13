import 'package:after_init/after_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_mmhelper/Models/FacebookModel.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:flutter_mmhelper/services/firestore_service.dart';
import 'package:flutter_mmhelper/ui/MainPage.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';
import 'package:flutter_mmhelper/ui/widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
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
  bool isLoading = false;
  String _message = '';
  String _verificationId;
  bool isShowSms = false;
  Facebookdata facebookdata = Facebookdata();
  final _service = FirestoreService.instance;
  SharedPreferences prefs;


  @override
  void didInitState() {
    getPhoneUserId().then((onValue){
      if(onValue != null){
        getUserPhone().then((onValue){
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
                return MainPage(
                  mobileNo: onValue,
                  isFromLogin: true,
                );
              }), (Route<dynamic> route) => false);
        });
      }else{
        var getCountryList = Provider.of<GetCountryListService>(context);
        getCountryList.getCountryList();
        getCountryList.newLoginCountry(newCountry: "Hong Kong",newCountryCode: "+852");
        _phoneNumberController.text = "96527733";
      }
    });

  }

  Future<String> getPhoneUserId()async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("PhoneUserId");
  }

  Future<String> getUserPhone()async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("UserPhone");
  }

  void _verifyPhoneNumber() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    if (getCountryList.selectedLoginCountryCode == "Select Code") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please select dial code"),
      ));
    } else if (_phoneNumberController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please enter mobile"),
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
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_message),
        ));
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Please check your phone for the verification code."),
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
              "${getCountryList.selectedLoginCountryCode}${_phoneNumberController.text}",
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
  }

  void _signInWithPhoneNumber() async {
    final database = Provider.of<FirestoreDatabase>(context);
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
          _message = 'Successfully signed in, uid: ' + user.uid;
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return MainPage(
              mobileNo: _phoneNumberController.text,
              isFromLogin: true,
            );
          }), (Route<dynamic> route) => false);
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
        content: Text("Please enter SMS code"),
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
          final emails = await database.flContentsStream().first;
          final allemail = emails.map((job) => job.email).toList();
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

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.grey)
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: false, decimal: false),
                                    cursorColor: Theme.of(context).accentColor,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.call),
                                        hintText: "Mobile Number",
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
                                            color:
                                                Colors.black.withOpacity(0.3)),
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
                                                signed: false, decimal: false),
                                        cursorColor:
                                            Theme.of(context).accentColor,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.sms),
                                            hintText: "Enter SMS code",
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
                                  "Not received? Resend SMS",
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
                        onPressed: () {
                          if (isShowSms) {
                            _signInWithPhoneNumber();
                          } else {
                            _verifyPhoneNumber();
                          }
                        },
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                        shape: RoundedRectangleBorder(),
                        color: Colors.pink.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
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
                                  return SignUpScreen();
                                }));
                              },
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )),
                              shape: RoundedRectangleBorder(),
                              color: Colors.red,
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
                                  return MamaProfile();
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
              ),
            ],
          )),
    );
  }
}
