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
  List<String> searchText = [];

  SearchPage({
    this.onChanged,
    this.listProfileData,
    this.searchText,
    this.listEducationData,
    this.eduStringList,
    this.religionStringList,
    this.maritalStringList,
    this.childrenStringList,
    this.jobTypeStringList,
    this.jobCapStringList,
    this.contractStringList,
    this.nationalityStringList,
    this.workingSkillStringList,
    this.languageStringList,
  });
}

class _SearchPageState extends State<SearchPage> with AfterInitMixin {
  Color gradientStart = Color(0xffbf9b30);

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
    setState(() {
      isLoading = true;
    });
    fetchLanguage().then((onValue) {
      languageCode = onValue;
      initData();
    });
  }

  initData() {
    setState(() {
      isLoading = true;
    });
    eduWidget = [];
    religionWidget = [];
    maritalStatusWidget = [];
    childrenWidget = [];
    jobTypeWidget = [];
    jobCapWidget = [];
    contractWidget = [];
    nationalityWidget = [];
    workingSkillWidget = [];
    languageWidget = [];
    searchController.text = widget.searchText[0];
    listEducationData.forEach((f) {
      eduWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.eduStringList,
        isSelected: widget.eduStringList.contains(f.nameId),
      ));
      eduWidget.add(SizedBox(
        width: 5,
      ));
    });
    listNationalityData.forEach((f) {
      nationalityWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.nationalityStringList,
        isSelected: widget.nationalityStringList.contains(f.nameId),
      ));
      nationalityWidget.add(SizedBox(
        width: 5,
      ));
    });
    listReligionData.forEach((f) {
      religionWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.religionStringList,
        isSelected: widget.religionStringList.contains(f.nameId),
      ));
      religionWidget.add(SizedBox(
        width: 5,
      ));
    });
    listMaritalData.forEach((f) {
      maritalStatusWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.maritalStringList,
        isSelected: widget.maritalStringList.contains(f.nameId),
      ));
      maritalStatusWidget.add(SizedBox(
        width: 5,
      ));
    });
    listChildrenData.forEach((f) {
      childrenWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.childrenStringList,
        isSelected: widget.childrenStringList.contains(f.nameId),
      ));
      childrenWidget.add(SizedBox(
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
    listJobCapData.forEach((f) {
      jobCapWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.jobCapStringList,
        isSelected: widget.jobCapStringList.contains(f.nameId),
      ));
      jobCapWidget.add(SizedBox(
        width: 5,
      ));
    });
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
    listWorkSkillData.forEach((f) {
      workingSkillWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.workingSkillStringList,
        isSelected: widget.workingSkillStringList.contains(f.nameId),
      ));
      workingSkillWidget.add(SizedBox(
        width: 5,
      ));
    });
    listLangData.forEach((f) {
      languageWidget.add(ChipsWidget(
        languageCode: languageCode,
        dataList: f,
        typeStringList: widget.languageStringList,
        isSelected: widget.languageStringList.contains(f.nameId),
      ));
      languageWidget.add(SizedBox(
        width: 5,
      ));
    });
    setState(() {
      isLoading = false;
    });
  }

  searchData() {
    widget.searchText[0] = searchController.text;
    if (widget.eduStringList.length == 0 &&
        widget.religionStringList.length == 0 &&
        widget.maritalStringList.length == 0 &&
        widget.childrenStringList.length == 0 &&
        widget.jobTypeStringList.length == 0 &&
        widget.jobCapStringList.length == 0 &&
        widget.contractStringList.length == 0 &&
        widget.workingSkillStringList.length == 0 &&
        widget.languageStringList.length == 0 &&
        widget.nationalityStringList.length == 0 &&
        widget.searchText[0] == "") {
      widget.onChanged(widget.listProfileData);
    } else {
      widget.listProfileData.forEach((element) {
        bool isAdd = false;

        if (widget.eduStringList.contains(element.education) ||
            widget.religionStringList.contains(element.religion) ||
            widget.maritalStringList.contains(element.marital) ||
            widget.childrenStringList.contains(element.children) ||
            widget.jobTypeStringList.contains(element.jobtype) ||
            widget.jobCapStringList.contains(element.jobcapacity) ||
            widget.contractStringList.contains(element.contract) ||
            widget.nationalityStringList.contains(element.nationality)) {
          isAdd = true;
          listOfCard.add(element);
        }

        if (!isAdd) {
          List<String> workskills = element.workskill.split(";");
          if (workskills != null && workskills.length > 0) {
            workskills.forEach((workskill) {
              if (widget.workingSkillStringList.contains(workskill) && !isAdd) {
                isAdd = true;
                listOfCard.add(element);
              }
            });
          } else {
            if (widget.workingSkillStringList.contains(element.workskill))
              listOfCard.add(element);
          }
        }

        if (!isAdd) {
          List<String> languages = element.language.split(";");
          if (languages != null && languages.length > 0) {
            languages.forEach((language) {
              if (widget.languageStringList.contains(language) && !isAdd) {
                isAdd = true;
                listOfCard.add(element);
              }
            });
          } else {
            if (widget.languageStringList.contains(element.language))
              listOfCard.add(element);
          }
        }
        if (!isAdd) {
          if (widget.searchText[0] != "") {
            if (element.selfintroduction != null &&
                element.firstname != null &&
                element.lastname != null) if (element.firstname
                    .toLowerCase()
                    .contains(widget.searchText[0].toLowerCase()) ||
                element.lastname
                    .toLowerCase()
                    .contains(widget.searchText[0].toLowerCase()) ||
                element.selfintroduction
                    .toLowerCase()
                    .contains(widget.searchText[0].toLowerCase())) {
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

                              if (widget.eduStringList.length > 0) {
                                for (int i = (widget.eduStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.eduStringList.removeAt(i);
                                }
                              }

                              if (widget.religionStringList.length > 0) {
                                for (int i =
                                        (widget.religionStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.religionStringList.removeAt(i);
                                }
                              }

                              if (widget.maritalStringList.length > 0) {
                                for (int i =
                                        (widget.maritalStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.maritalStringList.removeAt(i);
                                }
                              }

                              if (widget.childrenStringList.length > 0) {
                                for (int i =
                                        (widget.childrenStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.childrenStringList.removeAt(i);
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

                              if (widget.jobCapStringList.length > 0) {
                                for (int i =
                                        (widget.jobCapStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.jobCapStringList.removeAt(i);
                                }
                              }

                              if (widget.contractStringList.length > 0) {
                                for (int i =
                                        (widget.contractStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.contractStringList.removeAt(i);
                                }
                              }

                              if (widget.nationalityStringList.length > 0) {
                                for (int i =
                                        (widget.nationalityStringList.length -
                                            1);
                                    i >= 0;
                                    i--) {
                                  widget.nationalityStringList.removeAt(i);
                                }
                              }

                              if (widget.workingSkillStringList.length > 0) {
                                for (int i =
                                        (widget.workingSkillStringList.length -
                                            1);
                                    i >= 0;
                                    i--) {
                                  widget.workingSkillStringList.removeAt(i);
                                }
                              }

                              if (widget.languageStringList.length > 0) {
                                for (int i =
                                        (widget.languageStringList.length - 1);
                                    i >= 0;
                                    i--) {
                                  widget.languageStringList.removeAt(i);
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
                              searchController.clear();
                              widget.searchText[0] = '';
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
