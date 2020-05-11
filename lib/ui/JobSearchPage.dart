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

  JobSearchPage({this.onChanged, this.listJobData});
}

class _JobSearchPageState extends State<JobSearchPage> with AfterInitMixin {
  List<Widget> contractWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> accommodationWidget = [];

  List<String> contractStringList = [];
  List<String> jobTypeStringList = [];
  List<String> accommodationStringList = [];

  List<JobDetailData> listOfCard = [];
  String languageCode;
  bool isLoading = true;

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
    // TODO: implement initState
    super.initState();
    fetchLanguage().then((onValue) {
      languageCode = onValue;
      listContractData.forEach((f) {
        contractWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: contractStringList,
          isSelected: false,
        ));
        contractWidget.add(SizedBox(
          width: 5,
        ));
      });
      listAccommodationData.forEach((f) {
        accommodationWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: accommodationStringList,
          isSelected: false,
        ));
        accommodationWidget.add(SizedBox(
          width: 5,
        ));
      });
      listJobTypeData.forEach((f) {
        jobTypeWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: jobTypeStringList,
          isSelected: false,
        ));
        jobTypeWidget.add(SizedBox(
          width: 5,
        ));
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  searchData() {
    if (contractStringList.length == 0 &&
        jobTypeStringList.length == 0 &&
        accommodationStringList.length == 0 &&
        searchController.text == "") {
      widget.onChanged(widget.listJobData);
      print("call all");
    } else {
      widget.listJobData.forEach((element) {
        bool isAdd = false;

        if (contractStringList.contains(element.contractType) ||
            jobTypeStringList.contains(element.jobType) ||
            accommodationStringList.contains(element.accommodation)) {
          isAdd = true;
          listOfCard.add(element);
        }
        if (!isAdd) {
          if (searchController.text != "") {
            if (element.moreDescription != null) if (element.moreDescription
                .toLowerCase()
                .contains(searchController.text.toLowerCase())) {
              isAdd = true;
              listOfCard.add(element);
            }
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
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                      child: TextField(
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
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
                          .translate('Accommodation')),
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
              title,
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
    listContractData = appLanguage.listContractData;
    listJobTypeData = appLanguage.listJobTypeData;
    listAccommodationData = appLanguage.listAccommodationData;
  }
}
