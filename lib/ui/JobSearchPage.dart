import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/JobDetailDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/widgets/ChipsWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobSearchPage extends StatefulWidget {
  @override
  _JobSearchPageState createState() => _JobSearchPageState();
  final ValueChanged<List<JobDetailData>> onChanged;

  final List<JobDetailData> listJobData;

  List<String> contractStringList = [];
  List<String> jobTypeStringList = [];
  List<String> accommodationStringList = [];
  List<String> searchText = [];
  RangeValues rangeValues = RangeValues(0, 10000);

  JobSearchPage(
      {this.onChanged,
      this.listJobData,
      this.searchText,
      this.contractStringList,
      this.jobTypeStringList,
      this.accommodationStringList,this.rangeValues});
}

class _JobSearchPageState extends State<JobSearchPage> with AfterInitMixin {
  Color gradientStart = Color(0xffbf9b30);

  List<Widget> contractWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> accommodationWidget = [];
  
  List<JobDetailData> listOfCard = [];
  String languageCode;
  bool isLoading = true;
  List<DataList> listQuitReasonData = [];
  List<DataList> listContractData = [];
  List<DataList> listJobTypeData = [];
  List<DataList> listAccommodationData = [];

  TextEditingController searchController = new TextEditingController();

  Future<String> fetchLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code');
  }

  @override
  void initState() {
    super.initState();
    fetchLanguage().then((onValue) {
      languageCode = onValue;
      initData();
    });
  }

  RangeValues _values = RangeValues(0.3, 0.7);

  initData() {
    setState(() {
      isLoading = true;
    });
    contractWidget = [];
    jobTypeWidget = [];
    accommodationWidget = [];
    searchController.text = widget.searchText[0];

    listContractData.forEach((f) {
      contractWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.contractStringList,
        isSelected: widget.contractStringList.contains(f.nameId),
      ));
      contractWidget.add(SizedBox(
        width: 5,
      ));
    });

    listQuitReasonData.forEach((f) {
      contractWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.contractStringList,
        isSelected: widget.contractStringList.contains(f.nameId),
      ));
      contractWidget.add(SizedBox(
        width: 5,
      ));
    });

    listAccommodationData.forEach((f) {
      accommodationWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.accommodationStringList,
        isSelected: widget.accommodationStringList.contains(f.nameId),
      ));
      accommodationWidget.add(SizedBox(
        width: 5,
      ));
    });
    listJobTypeData.forEach((f) {
      jobTypeWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.jobTypeStringList,
        isSelected: widget.jobTypeStringList.contains(f.nameId),
      ));
      jobTypeWidget.add(SizedBox(
        width: 5,
      ));
    });
    setState(() {
      isLoading = false;
    });
  }

  searchData() {
    widget.searchText[0] = searchController.text;
    if (widget.contractStringList.length == 0 &&
        widget.jobTypeStringList.length == 0 &&
        widget.accommodationStringList.length == 0 &&
        widget.searchText[0] == ""&&
    widget.rangeValues ==  RangeValues(0, 10000)) {
      widget.onChanged(widget.listJobData);
    } else {
      widget.listJobData.forEach((element) {
        bool isAdd = false;

        if (widget.contractStringList.contains(element.contractType) ||
            widget.jobTypeStringList.contains(element.jobType) ||
            widget.accommodationStringList.contains(element.accommodation)) {
          isAdd = true;
          listOfCard.add(element);
        }
        if (!isAdd) {
          if (widget.searchText[0] != "") {
            if (element.moreDescription != null) if (element.moreDescription
                .toLowerCase()
                .contains(widget.searchText[0].toLowerCase())) {
              isAdd = true;
              listOfCard.add(element);
            }
          }
        }
        if (!isAdd) {
          if (int.parse(element.salary) >= widget.rangeValues.start &&
              int.parse(element.salary) <= widget.rangeValues.end) {
            isAdd = true;
            listOfCard.add(element);
          }
        }
      });
      print(listOfCard.length);
      widget.onChanged(listOfCard);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Job_Search')),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                searchData();
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          height: 30,
                          child: FlatButton(
                            onPressed: () {
                              print('Clear All');

                              searchController.clear();
                              widget.searchText[0] = '';

                              if (widget.contractStringList.length > 0) {
                                for (int i =
                                        (widget.contractStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.contractStringList.removeAt(i);
                                }
                              }

                              if (widget.jobTypeStringList.length > 0) {
                                for (int i =
                                        (widget.jobTypeStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.jobTypeStringList.removeAt(i);
                                }
                              }

                              if (widget.accommodationStringList.length > 0) {
                                for (int i =
                                        (widget.accommodationStringList.length -
                                            1);
                                    i >= 0;
                                    i--) {
                                  widget.accommodationStringList.removeAt(i);
                                }
                              }

                              FocusScope.of(context).requestFocus(FocusNode());
                              initData();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: gradientStart,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('Clear_All'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                      child: TextField(
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              widget.searchText[0] = '';
                              searchController.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                          hintText:
                              AppLocalizations.of(context).translate('Search'),
                        ),
                        controller: searchController,
                      )),
                  chipsCardWidget(
                      widgetList: jobTypeWidget,
                      title:
                          AppLocalizations.of(context).translate('Job_Type')),
                  chipsCardWidget(
                      widgetList: contractWidget,
                      title: AppLocalizations.of(context)
                          .translate('Contract_Status')),
                  chipsCardWidget(
                      widgetList: accommodationWidget,
                      title: AppLocalizations.of(context)
                          .translate('accommodation')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Salary Range",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Card(
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(widget.rangeValues.start
                                          .round()
                                          .toString()),
                                      Expanded(
                                        child: RangeSlider(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          inactiveColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          values: widget.rangeValues,
                                          divisions: 100,
                                          min: 0.0,
                                          max: 10000.0,
                                          labels: RangeLabels(
                                              widget.rangeValues.start
                                                  .round()
                                                  .toString(),
                                              widget.rangeValues.end
                                                  .round()
                                                  .toString()),
                                          onChanged: (RangeValues newValues) {
                                            setState(() {
                                              widget.rangeValues = newValues;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(widget.rangeValues.end.round().toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
              child: isLoading
                  ? Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox())
        ],
      ),
    );
  }

  Widget chipsCardWidget({List<Widget> widgetList, String title}) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title ?? "",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Card(
            child: Container(
              width: SizeConfig.screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  children: widgetList,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
    var appLanguage = Provider.of<DataListService>(context);
    listQuitReasonData = appLanguage.listQuitReasonData;
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listAccommodationData = appLanguage.listAccommodationData;
  }
}
