import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/EducationListModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'package:flutter_mmhelper/services/size_config.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
  final ValueChanged<List<ProfileData>> onChanged;
  final List<ProfileData> listProfileData;
  final List<EducationList> listEducationData;

  SearchPage({this.onChanged, this.listProfileData, this.listEducationData});
}

class _SearchPageState extends State<SearchPage> {
  List<Widget> eduWidget = [];
  List<Widget> religionWidget = [];
  List<Widget> maritalStatusWidget = [];
  List<Widget> childrenWidget = [];
  List<Widget> jobTypeWidget = [];
  List<Widget> jobCapWidget = [];
  List<Widget> contractWidget = [];
  List<Widget> workingSkillWidget = [];
  List<Widget> languageWidget = [];
  List<String> eduStringList = [];
  List<String> religionStringList = [];
  List<String> maritalStringList = [];
  List<String> childrenStringList = [];
  List<String> jobTypeStringList = [];
  List<String> jobCapStringList = [];
  List<String> contractStringList = [];
  List<String> workingSkillStringList = [];
  List<String> languageStringList = [];
  List<ProfileData> listOfCard = [];
  String languageCode;
  bool isLoading = true;

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
      widget.listEducationData.forEach((f) {
        eduWidget.add(ChipsWidget(
          title: languageCode == "en" ? f.nameEn : f.nameZh,
          typeStringList: eduStringList,
          isSelected: false,
        ));
        eduWidget.add(SizedBox(
          width: 5,
        ));
      });
      setState(() {
        isLoading = false;
      });
    });

    religion.forEach((f) {
      religionWidget.add(ChipsWidget(
        title: f,
        typeStringList: religionStringList,
        isSelected: false,
      ));
      religionWidget.add(SizedBox(
        width: 5,
      ));
    });
    marital.forEach((f) {
      maritalStatusWidget.add(ChipsWidget(
        title: f,
        typeStringList: maritalStringList,
        isSelected: false,
      ));
      maritalStatusWidget.add(SizedBox(
        width: 5,
      ));
    });
    children.forEach((f) {
      childrenWidget.add(ChipsWidget(
        title: f,
        typeStringList: childrenStringList,
        isSelected: false,
      ));
      childrenWidget.add(SizedBox(
        width: 5,
      ));
    });
    jobtype.forEach((f) {
      jobTypeWidget.add(ChipsWidget(
        title: f,
        typeStringList: jobTypeStringList,
        isSelected: false,
      ));
      jobTypeWidget.add(SizedBox(
        width: 5,
      ));
    });
    jobcapacity.forEach((f) {
      jobCapWidget.add(ChipsWidget(
        title: f,
        typeStringList: jobCapStringList,
        isSelected: false,
      ));
      jobCapWidget.add(SizedBox(
        width: 5,
      ));
    });
    contract.forEach((f) {
      contractWidget.add(ChipsWidget(
        title: f,
        typeStringList: contractStringList,
        isSelected: false,
      ));
      contractWidget.add(SizedBox(
        width: 5,
      ));
    });
    texttags.forEach((f) {
      workingSkillWidget.add(ChipsWidget(
        title: f,
        typeStringList: workingSkillStringList,
        isSelected: false,
      ));
      workingSkillWidget.add(SizedBox(
        width: 5,
      ));
    });
    language.forEach((f) {
      languageWidget.add(ChipsWidget(
        title: f,
        typeStringList: languageStringList,
        isSelected: false,
      ));
      languageWidget.add(SizedBox(
        width: 5,
      ));
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
        languageStringList.length == 0) {
      widget.onChanged(widget.listProfileData);
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
            workingSkillStringList.contains(element.workskill)) {
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
        title: Text("Category Search"),
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
                  chipsCardWidget(widgetList: eduWidget, title: 'Education'),
                  chipsCardWidget(
                      widgetList: religionWidget, title: 'Religion'),
                  chipsCardWidget(
                      widgetList: maritalStatusWidget, title: 'Marital'),
                  chipsCardWidget(
                      widgetList: childrenWidget, title: 'Children'),
                  chipsCardWidget(widgetList: jobTypeWidget, title: 'Job Type'),
                  chipsCardWidget(
                      widgetList: jobCapWidget, title: 'Job Capacity'),
                  chipsCardWidget(
                      widgetList: contractWidget, title: 'Contract'),
                  chipsCardWidget(
                      widgetList: workingSkillWidget, title: 'Working Skill'),
                  chipsCardWidget(
                      widgetList: languageWidget, title: 'Language'),
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
}

class ChipsWidget extends StatefulWidget {
  @override
  _ChipsWidgetState createState() => _ChipsWidgetState();
  final String title;
  List<String> typeStringList;
  bool isSelected;

  ChipsWidget({this.title, this.typeStringList, this.isSelected});
}

class _ChipsWidgetState extends State<ChipsWidget> {
  bool isSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.isSelected;
    if (isSelected) {
      widget.typeStringList.add(widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(widget.title),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          isSelected = selected;
          if (isSelected == true) {
            widget.typeStringList.add(widget.title);
            print(widget.typeStringList);
          } else {
            widget.typeStringList
                .removeAt(widget.typeStringList.indexOf(widget.title));
            print(widget.typeStringList);
          }
        });
      },
      selectedColor: Colors.pink,
      checkmarkColor: Colors.black,
    );
  }
}
