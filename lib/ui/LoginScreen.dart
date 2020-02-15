import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:flutter_mmhelper/ui/SignUpScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'widgets/CountryListPopup.dart';
import 'widgets/platform_exception_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AfterInitMixin{
  final TextEditingController mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didInitState() {
    var getCountryList = Provider.of<GetCountryListService>(context);
    getCountryList.getCountryList();
  }

  Future<void> _submit() async {
    var getCountryList = Provider.of<GetCountryListService>(context);
    if (getCountryList.selectedCountryCode == "Select Code") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please select dial code"),
      ));
    } else if (mobileController.text == "") {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please enter mobile"),
      ));
    } else {
      try {

      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text("Login",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        getCountryList.selectedLoginCountry,
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
                                                return StateListPopup(isFromLogin: true,);
                                              });
                                        },
                                        child: Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.3)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              controller: mobileController,
                                              keyboardType:
                                                  TextInputType.numberWithOptions(
                                                      signed: false,
                                                      decimal: false),
                                              cursorColor:
                                                  Theme.of(context).accentColor,
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
                      ))),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SignUpScreen();
                          }));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
