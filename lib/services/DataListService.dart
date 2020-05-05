import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/services/database.dart';
import 'package:provider/provider.dart';

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

    final database = Provider.of<FirestoreDatabase>(context);
    database.mbEducationStream().first.then((contents) {
      contents.forEach((element) async {
        listEducationData.add(element);
      });
      notifyListeners();
    });
    database.mbReligionStream().first.then((contents) {
      contents.forEach((element) async {
        listReligionData.add(element);
      });
      notifyListeners();
    });
    database.mbMaritalStream().first.then((contents) {
      contents.forEach((element) async {
        listMaritalData.add(element);
      });
      notifyListeners();
    });
    database.mbChildrenStream().first.then((contents) {
      contents.forEach((element) async {
        listChildrenData.add(element);
      });
      notifyListeners();
    });
    database.mbJobTypeStream().first.then((contents) {
      contents.forEach((element) async {
        listJobTypeData.add(element);
      });
      notifyListeners();
    });
    database.mbJobCapStream().first.then((contents) {
      contents.forEach((element) async {
        listJobCapData.add(element);
      });
      notifyListeners();
    });
    database.mbContractStream().first.then((contents) {
      contents.forEach((element) async {
        listContractData.add(element);
      });
      notifyListeners();
    });
    database.mbWorkSkillStream().first.then((contents) {
      contents.forEach((element) async {
        listWorkSkillData.add(element);
      });
      notifyListeners();
    });
    database.mbLangStream().first.then((contents) {
      contents.forEach((element) async {
        listLangData.add(element);
      });
      notifyListeners();
    });
    database.mbNationalityStream().first.then((contents) {
      contents.forEach((element) async {
        listNationalityData.add(element);
      });
      notifyListeners();
    });
    database.mbLocationStream().first.then((contents) {
      contents.forEach((element) async {
        listLocationData.add(element);
      });
      notifyListeners();
    });
    database.mbRoleStream().first.then((contents) {
      contents.forEach((element) async {
        listRoleData.add(element);
      });
      notifyListeners();
    });
  }
}
