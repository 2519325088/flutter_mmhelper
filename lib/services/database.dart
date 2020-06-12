import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';
import 'package:flutter_mmhelper/Models/FacebookModel.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mmhelper/Models/FlImageModel.dart';
import 'package:flutter_mmhelper/Models/JobDetailDataModel.dart';
import 'package:flutter_mmhelper/Models/PostJobModel.dart';
import 'package:flutter_mmhelper/Models/ProfileDataModel.dart';
import 'api_path.dart';
import 'firestore_service.dart';

class FirestoreDatabase with ChangeNotifier {
  /*FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
*/
  final _service = FirestoreService.instance;
  var dio = Dio();
  String lastUserId;
  bool isFirst = true;
  String downloadImageLink;

  String documentIdFromCurrentDate() {
    final string = DateTime.now().toIso8601String();
    lastUserId = string;
    return lastUserId;
  }

  Future<void> createUser(FlContent flContent, String userId) async {
    documentIdFromCurrentDate();
    flContent.userId = userId;
    await _service.setData(
      path: APIPath.newCandidate(userId),
      data: flContent.toMap(),
    );
  }

  Stream<List<ProfileData>> flContentsStream() => _service.collectionStream(
        path: APIPath.candidateList(),
        builder: (data, documentId) => ProfileData.fromMap(data),
      );

  Stream<List<FlContent>> flUserStream() => _service.collectionStream(
        path: APIPath.userList(),
        builder: (data, documentId) => FlContent.fromMap(data),
      );

  Stream<List<JobDetailData>> flJobStream() => _service.jobCollectionStream(
        path: APIPath.jobList(),
        builder: (data, documentId) => JobDetailData.fromMap(data),
      );

  Stream<List<DataList>> mbEducationStream() => _service.collectionStream(
        path: APIPath.educationList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbReligionStream() => _service.collectionStream(
        path: APIPath.religionList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbMaritalStream() => _service.collectionStream(
        path: APIPath.maritalList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbChildrenStream() => _service.collectionStream(
        path: APIPath.childrenList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbJobTypeStream() => _service.collectionStream(
        path: APIPath.jobTypeList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbJobCapStream() => _service.collectionStream(
        path: APIPath.jobCapList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbContractStream() => _service.collectionStream(
        path: APIPath.contractList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbWorkSkillStream() => _service.collectionStream(
        path: APIPath.workSkillList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbLangStream() => _service.collectionStream(
        path: APIPath.langList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbNationalityStream() => _service.collectionStream(
        path: APIPath.nationalityList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbLocationStream() => _service.collectionStream(
        path: APIPath.locationList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbRoleStream() => _service.collectionStream(
        path: APIPath.roleList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbAccommodationStream() => _service.collectionStream(
        path: APIPath.accommodationList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbHolidayNoStream() => _service.collectionStream(
        path: APIPath.weekHolidayList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbQuitReasonStream() => _service.collectionStream(
        path: APIPath.quitReasonList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Stream<List<DataList>> mbQuitReasonHkStream() => _service.collectionStream(
        path: APIPath.quitReasonHkList(),
        builder: (data, documentId) => DataList.fromMap(data),
      );

  Future<Facebookdata> facebookCall(
    _scaffoldKey,
    String token,
  ) async {
    try {
      final graphResponse = await dio.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');

      final profile = json.decode(graphResponse.data);
      return Facebookdata.fromJson(Map<String, dynamic>.from(profile));
    } catch (error) {
      print(error);
    }
  }
}
