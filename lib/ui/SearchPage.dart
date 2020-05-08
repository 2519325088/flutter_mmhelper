import 'package:after_init/after_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/DataListService.dart';
import 'package:flutter_mmhelper/services/app_localizations.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/ui/widgets/ChipsWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
  final ValueChanged<List<ProfileData>> onChanged;
  final List<ProfileData> listProfileData;
  final List<DataList> listEducationData;

  SearchPage({this.onChanged, this.listProfileData, this.listEducationData});
}

class _SearchPageState extends State<SearchPage> with AfterInitMixin {
  List<Widget> eduWidget = [];
  List<Widget> religionWidget = [];
  List<Widget> maritalStatusWidget = [];
  List<Widget> childrenWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> jobCapWidget = [];
  List<Widget> contractWidget = [];
  List<Widget> nationalityWidget = [];
  List<Widget> workingSkillWidget = [];
  List<Widget> languageWidget = [];

  List<String> eduStringList = [];
  List<String> religionStringList = [];
  List<String> maritalStringList = [];
  List<String> childrenStringList = [];
  List<String> jobTypeStringList = [];
  List<String> jobCapStringList = [];
  List<String> contractStringList = [];
  List<String> nationalityStringList = [];
  List<String> workingSkillStringList = [];
  List<String> languageStringList = [];

  List<ProfileData> listOfCard = [];
  String languageCode;
  bool isLoading = true;

  List<DataList> listEducationData = [];
  List<DataList> listReligionData = [];
  List<DataList> listMaritalData = [];
  List<DataList> listChildrenData = [];
  List<DataList> listJobTypeData = [];
  List<DataList> listJobCapData = [];
  List<DataList> listContractData = [];
  List<DataList> listNationalityData = [];
  List<DataList> listWorkSkillData = [];
  List<DataList> listLangData = [];
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
      listEducationData.forEach((f) {
        eduWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: eduStringList,
          isSelected: false,
        ));
        eduWidget.add(SizedBox(
          width: 5,
        ));
      });
      listNationalityData.forEach((f) {
        nationalityWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: nationalityStringList,
          isSelected: false,
        ));
        nationalityWidget.add(SizedBox(
          width: 5,
        ));
      });
      listReligionData.forEach((f) {
        religionWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: religionStringList,
          isSelected: false,
        ));
        religionWidget.add(SizedBox(
          width: 5,
        ));
      });
      listMaritalData.forEach((f) {
        maritalStatusWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: maritalStringList,
          isSelected: false,
        ));
        maritalStatusWidget.add(SizedBox(
          width: 5,
        ));
      });
      listChildrenData.forEach((f) {
        childrenWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: childrenStringList,
          isSelected: false,
        ));
        childrenWidget.add(SizedBox(
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
      listJobCapData.forEach((f) {
        jobCapWidget.add(ChipsWidget(
          languageCode: languageCode,
          dataList: f,
          typeStringList: jobCapStringList,
          isSelected: false,
        ));
        jobCapWidget.add(SizedBox(
          width: 5,
        ));
      });
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
      setState(() {
        isLoading = false;
      });
    });
  }

  searchData() {
    if (eduStringList.length == 0 &&
        religionStringList.length == 0 &&
        maritalStringList.length == 0 &&
        childrenStringList.length == 0 &&
        jobTypeStringList.length == 0 &&
        jobCapStringList.length == 0 &&
        contractStringList.length == 0 &&
        workingSkillStringList.length == 0 &&
        languageStringList.length == 0 &&
        nationalityStringList.length == 0 &&
        searchController.text == "") {
      widget.onChanged(widget.listProfileData);
      print("call all");
    } else {
      widget.listProfileData.forEach((element) {
        bool isAdd = false;

        if (eduStringList.contains(element.education) ||
            religionStringList.contains(element.religion) ||
            maritalStringList.contains(element.marital) ||
            childrenStringList.contains(element.children) ||
            jobTypeStringList.contains(element.jobtype) ||
            jobCapStringList.contains(element.jobcapacity) ||
            contractStringList.contains(element.contract) ||
            workingSkillStringList.contains(element.workskill) ||
            nationalityStringList.contains(element.nationality)) {
          isAdd = true;
          listOfCard.add(element);
        }
        if (!isAdd) {
          List<String> languages = element.language.split(";");
          if (languages != null && languages.length > 0) {
            languages.forEach((language) {
              if (languageStringList.contains(language) && !isAdd) {
                isAdd = true;
                listOfCard.add(element);
              }
            });
          } else {
            if (languageStringList.contains(element.language))
              listOfCard.add(element);
          }
        }
        if (!isAdd) {
          if (searchController.text != "") {
            if (element.selfintroduction != null &&
                element.firstname != null &&
                element.lastname != null) if (element.firstname
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                element.lastname
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                element.selfintroduction
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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Category_Search')),
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
                          hintText: "Search",
                        ),
                        controller: searchController,
                      )),
                  chipsCardWidget(
                      widgetList: eduWidget,
                      title:
                          AppLocalizations.of(context).translate('Education')),
                  chipsCardWidget(
                      widgetList: nationalityWidget,
                      title: AppLocalizations.of(context)
                          .translate('Nationality')),
                  chipsCardWidget(
                      widgetList: religionWidget,
                      title:
                          AppLocalizations.of(context).translate('Religion')),
                  chipsCardWidget(
                      widgetList: maritalStatusWidget,
                      title: AppLocalizations.of(context)
                          .translate('Marital_Status')),
                  chipsCardWidget(
                      widgetList: childrenWidget,
                      title:
                          AppLocalizations.of(context).translate('Children')),
                  chipsCardWidget(
                      widgetList: jobTypeWidget,
                      title:
                          AppLocalizations.of(context).translate('Job_Type')),
                  chipsCardWidget(
                      widgetList: jobCapWidget,
                      title: AppLocalizations.of(context)
                          .translate('Job_Capacity')),
                  chipsCardWidget(
                      widgetList: contractWidget,
                      title: AppLocalizations.of(context)
                          .translate('Contract_Status')),
                  chipsCardWidget(
                      widgetList: workingSkillWidget,
                      title: AppLocalizations.of(context)
                          .translate('Working_Skill')),
                  chipsCardWidget(
                      widgetList: languageWidget,
                      title:
                          AppLocalizations.of(context).translate('Language')),
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
  }
}
