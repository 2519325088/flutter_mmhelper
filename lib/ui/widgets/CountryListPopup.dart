import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/CountryCodeModel.dart';
import 'package:flutter_mmhelper/services/GetCountryListService.dart';
import 'package:provider/provider.dart';

class StateListPopup extends StatefulWidget {
  @override
  State createState() => StateListPopupState();

  StateListPopup({this.isFromLogin, this.onChanged,this.isFromProfile});

  final ValueChanged<String> onChanged;
  bool isFromLogin;
  bool isFromProfile;
}

class StateListPopupState extends State<StateListPopup> {
  List<CountryCode> countryList = new List<CountryCode>();
  TextEditingController searchController = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();

    //fill countries with objects
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var getCountryList = Provider.of<GetCountryListService>(context);
    countryList = getCountryList.listCountry;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"))
              ],
            ),
            Expanded(
              child: new Material(
                  color: Colors.transparent,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.only(
                              top: 8.0, left: 16.0, right: 16.0),
                          child: new TextField(
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: new Icon(Icons.search),
                              suffixIcon: new IconButton(
                                icon: new Icon(Icons.close),
                                onPressed: () {
                                  searchController.clear();
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                              ),
                              hintText: "Search...",
                            ),
                            controller: searchController,
                          )),
                      new Expanded(
                        child: _buildListView(),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: countryList.length,
        itemBuilder: (BuildContext context, int index) {
          if (filter == null || filter == "") {
            return _buildRow(countryList[index]);
          } else {
            if (countryList[index]
                .name
                .toLowerCase()
                .contains(filter.toLowerCase())) {
              return _buildRow(countryList[index]);
            } else {
              return new Container();
            }
          }
        });
  }

  Widget _buildRow(CountryCode c) {
    var getCityList = Provider.of<GetCountryListService>(context);
    return new ListTile(
      onTap: () {
        if (widget.isFromProfile == true) {
          widget.onChanged(c.name);
        } else {
          if (widget.isFromLogin) {
            getCityList.newLoginCountry(
                newCountry: c.name, newCountryCode: c.dialCode);
          } else {
            getCityList.newCountry(
                newCountry: c.name, newCountryCode: c.dialCode);
          }
        }

        Navigator.pop(context);
      },
      title: new Text(
        "${c.dialCode} ${c.name}",
      ),
    );
  }
}
