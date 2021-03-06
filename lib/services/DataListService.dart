import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:provider/provider.dart';

import 'api_path.dart';

class DataListService with ChangeNotifier {
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
  List<DataList> listRoleData = [];
  List<DataList> listWeekHolidayData = [];
  List<DataList> listAccommodationData = [];
  List<DataList> listQuitReasonData = [];
  List<DataList> listQuitReasonHkData = [];

  LinkedHashMap listMapEducationData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapReligionData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapMaritalData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapChildrenData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapJobTypeData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapJobCapData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapContractData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapWorkSkillData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapLangData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapNationalityData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapLocationData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapRoleData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapWeekHolidayData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapAccommodationData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapQuitReasonData = LinkedHashMap<String, DataList>();
  LinkedHashMap listMapQuitReasonHkData = LinkedHashMap<String, DataList>();

  callListData(context) async {
    listEducationData = [];
    listReligionData = [];
    listMaritalData = [];
    listChildrenData = [];
    listJobTypeData = [];
    listJobCapData = [];
    listContractData = [];
    listWorkSkillData = [];
    listLangData = [];
    listNationalityData = [];
    listLocationData = [];
    listRoleData = [];
    listWeekHolidayData = [];
    listAccommodationData = [];
    listQuitReasonData = [];
    listQuitReasonHkData = [];

    listMapEducationData = LinkedHashMap<String, DataList>();
    listMapReligionData = LinkedHashMap<String, DataList>();
    listMapMaritalData = LinkedHashMap<String, DataList>();
    listMapChildrenData = LinkedHashMap<String, DataList>();
    listMapJobTypeData = LinkedHashMap<String, DataList>();
    listMapJobCapData = LinkedHashMap<String, DataList>();
    listMapContractData = LinkedHashMap<String, DataList>();
    listMapWorkSkillData = LinkedHashMap<String, DataList>();
    listMapLangData = LinkedHashMap<String, DataList>();
    listMapNationalityData = LinkedHashMap<String, DataList>();
    listMapLocationData = LinkedHashMap<String, DataList>();
    listMapRoleData = LinkedHashMap<String, DataList>();
    listMapWeekHolidayData = LinkedHashMap<String, DataList>();
    listMapAccommodationData = LinkedHashMap<String, DataList>();
    listMapQuitReasonData = LinkedHashMap<String, DataList>();
    listMapQuitReasonHkData = LinkedHashMap<String, DataList>();

    Firestore.instance
        .collection(APIPath.quitReasonHkList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listQuitReasonHkData.add(element);
          listMapQuitReasonHkData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbQuitReasonHkStream().first.then((contents) {
      contents.forEach((element) async {
        listQuitReasonHkData.add(element);
        listMapQuitReasonHkData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.quitReasonList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listQuitReasonData.add(element);
          listMapQuitReasonData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbQuitReasonStream().first.then((contents) {
      contents.forEach((element) async {
        listQuitReasonData.add(element);
        listMapQuitReasonData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.accommodationList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listAccommodationData.add(element);
          listMapAccommodationData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbAccommodationStream().first.then((contents) {
      contents.forEach((element) async {
        listAccommodationData.add(element);
        listMapAccommodationData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.weekHolidayList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listWeekHolidayData.add(element);
          listMapWeekHolidayData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbHolidayNoStream().first.then((contents) {
      contents.forEach((element) async {
        listWeekHolidayData.add(element);
        listMapWeekHolidayData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.educationList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listEducationData.add(element);
          listMapEducationData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbEducationStream().first.then((contents) {
      contents.forEach((element) async {
        listEducationData.add(element);
        listMapEducationData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.religionList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listReligionData.add(element);
          listMapReligionData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbReligionStream().first.then((contents) {
      contents.forEach((element) async {
        listReligionData.add(element);
        listMapReligionData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.maritalList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listMaritalData.add(element);
          listMapMaritalData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbMaritalStream().first.then((contents) {
      contents.forEach((element) async {
        listMaritalData.add(element);
        listMapMaritalData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.childrenList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listChildrenData.add(element);
          listMapChildrenData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbChildrenStream().first.then((contents) {
      contents.forEach((element) async {
        listChildrenData.add(element);
        listMapChildrenData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.jobTypeList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listJobTypeData.add(element);
          listMapJobTypeData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbJobTypeStream().first.then((contents) {
      contents.forEach((element) async {
        listJobTypeData.add(element);
        listMapJobTypeData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.jobCapList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listJobCapData.add(element);
          listMapJobCapData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbJobCapStream().first.then((contents) {
      contents.forEach((element) async {
        listJobCapData.add(element);
        listMapJobCapData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.contractList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listContractData.add(element);
          listMapContractData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbContractStream().first.then((contents) {
      contents.forEach((element) async {
        listContractData.add(element);
        listMapContractData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.workSkillList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listWorkSkillData.add(element);
          listMapWorkSkillData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbWorkSkillStream().first.then((contents) {
      contents.forEach((element) async {
        listWorkSkillData.add(element);
        listMapWorkSkillData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.langList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listLangData.add(element);
          listMapLangData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbLangStream().first.then((contents) {
      contents.forEach((element) async {
        listLangData.add(element);
        listMapLangData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.nationalityList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listNationalityData.add(element);
          listMapNationalityData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbNationalityStream().first.then((contents) {
      contents.forEach((element) async {
        listNationalityData.add(element);
        listMapNationalityData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.locationList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listLocationData.add(element);
          listMapLocationData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbLocationStream().first.then((contents) {
      contents.forEach((element) async {
        listLocationData.add(element);
        listMapLocationData[element.nameId] = element;
      });
      notifyListeners();
    });*/

    Firestore.instance
        .collection(APIPath.roleList())
        .getDocuments()
        .then((snapshot) async {
      if (snapshot != null &&
          snapshot.documents != null &&
          snapshot.documents.length > 0) {
        int dataCount = 0;
        do {
          DataList element =
              DataList.fromMap(snapshot.documents[dataCount].data);
          listRoleData.add(element);
          listMapRoleData[element.nameId] = element;
          dataCount++;
        } while (dataCount < snapshot.documents.length);
        notifyListeners();
      }
    });

    /*database.mbRoleStream().first.then((contents) {
      contents.forEach((element) async {
        listRoleData.add(element);
        listMapRoleData[element.nameId] = element;
      });
      notifyListeners();
    });*/
  }

  String getQuitReasonHkValue({String languageCode, String quitReasonHk}) {
    if (quitReasonHk == null) {
      return '';
    }
    if (listMapQuitReasonHkData != null && listMapQuitReasonHkData.length > 0) {
      DataList dataList = listMapQuitReasonHkData[quitReasonHk];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return quitReasonHk;
  }

  String getQuitReasonValue({String languageCode, String quitReason}) {
    if (quitReason == null) {
      return '';
    }
    if (listMapQuitReasonData != null && listMapQuitReasonData.length > 0) {
      DataList dataList = listMapQuitReasonData[quitReason];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return quitReason;
  }

  String getNationalityValue({String languageCode, String nationality}) {
    if (nationality == null) {
      return '';
    }
    if (listMapNationalityData != null && listMapNationalityData.length > 0) {
      DataList dataList = listMapNationalityData[nationality];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return nationality;
  }

  String getEducationValue({String languageCode, String education}) {
    if (education == null) {
      return '';
    }
    if (listMapEducationData != null && listMapEducationData.length > 0) {
      DataList dataList = listMapEducationData[education];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return education;
  }

  String getReligionValue({String languageCode, String religion}) {
    if (religion == null) {
      return '';
    }
    if (listMapReligionData != null && listMapReligionData.length > 0) {
      DataList dataList = listMapReligionData[religion];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return religion;
  }

  String getMaritalValue({String languageCode, String marital}) {
    if (marital == null) {
      return '';
    }
    if (listMapMaritalData != null && listMapMaritalData.length > 0) {
      DataList dataList = listMapMaritalData[marital];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return marital;
  }

  String getChildrenValue({String languageCode, String children}) {
    if (children == null) {
      return '';
    }
    if (listMapChildrenData != null && listMapChildrenData.length > 0) {
      DataList dataList = listMapChildrenData[children];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return children;
  }

  String getCurrentLocationValue({String languageCode, String location}) {
    if (location == null) {
      return '';
    }
    if (listMapLocationData != null && listMapLocationData.length > 0) {
      DataList dataList = listMapLocationData[location];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return location;
  }

  String getJobTypeValue({String languageCode, String jobtype}) {
    if (jobtype == null) {
      return '';
    }
    if (listMapJobTypeData != null && listMapJobTypeData.length > 0) {
      DataList dataList = listMapJobTypeData[jobtype];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return jobtype;
  }

  String getJobCapacityValue({String languageCode, String jobcapacity}) {
    if (jobcapacity == null) {
      return '';
    }
    if (listMapJobCapData != null && listMapJobCapData.length > 0) {
      DataList dataList = listMapJobCapData[jobcapacity];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return jobcapacity;
  }

  String getContractValue({String languageCode, String contract}) {
    if (contract == null) {
      return '';
    }
    if (listMapContractData != null && listMapContractData.length > 0) {
      DataList dataList = listMapContractData[contract];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return contract;
  }

  String getWorkSkillValue({String languageCode, String workskill}) {
    if (workskill == null) {
      return '';
    }
    if (listMapWorkSkillData != null && listMapWorkSkillData.length > 0) {
      List<String> workskills = workskill.split(";");

      if (workskills != null && workskills.length > 0) {
        String strWorkSkills = '';
        workskills.forEach((language) {
          DataList dataList = listMapWorkSkillData[language];
          if (dataList != null) {
            strWorkSkills = strWorkSkills +
                (languageCode == "en" ? dataList.nameEn : dataList.nameZh) +
                "; ";
          }
        });
        return strWorkSkills;
      }
    }
    return workskill;
  }

  String getLanguageValue({String languageCode, String language}) {
    if (language == null) {
      return '';
    }
    if (listMapLangData != null && listMapLangData.length > 0) {
      List<String> languages = language.split(";");

      if (languages != null && languages.length > 0) {
        String strLanguages = '';
        languages.forEach((language) {
          DataList dataList = listMapLangData[language];
          if (dataList != null) {
            strLanguages = strLanguages +
                (languageCode == "en" ? dataList.nameEn : dataList.nameZh) +
                "; ";
          }
        });
        return strLanguages;
      }
    }

    return language;
  }

  String getRoleValue({String languageCode, String role}) {
    if (role == null) {
      return '';
    }
    if (listMapRoleData != null && listMapRoleData.length > 0) {
      DataList dataList = listMapRoleData[role];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return role;
  }

  String getWeekHolidayValue({String languageCode, String weekholiday}) {
    if (weekholiday == null) {
      return '';
    }
    if (listMapWeekHolidayData != null && listMapWeekHolidayData.length > 0) {
      DataList dataList = listMapWeekHolidayData[weekholiday];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return weekholiday;
  }

  String getAccommodationValue({String languageCode, String accommodation}) {
    if (accommodation == null) {
      return '';
    }
    if (listMapAccommodationData != null &&
        listMapAccommodationData.length > 0) {
      DataList dataList = listMapAccommodationData[accommodation];
      if (dataList != null) {
        return languageCode == "en" ? dataList.nameEn : dataList.nameZh;
      }
    }
    return accommodation;
  }
}
