import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/FacebookModel.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mmhelper/Models/FlImageModel.dart';
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

  Future<void> createUser(FlContent flContent) async {
    documentIdFromCurrentDate();
    flContent.userId = lastUserId;
    await _service.setData(
      path: APIPath.newCandidate(lastUserId),
      data: flContent.toMap(),
    );
  }

  Stream<List<ProfileData>> flContentsStream() => _service.collectionStream(
        path: APIPath.candidateList(),
        builder: (data, documentId) => ProfileData.fromMap(data),
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
