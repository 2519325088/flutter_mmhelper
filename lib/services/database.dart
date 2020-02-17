import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_mmhelper/Models/FacebookModel.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:dio/dio.dart';
import 'api_path.dart';
import 'firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase with ChangeNotifier {
  /*FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
*/
  final _service = FirestoreService.instance;
  var dio = Dio();

  Future<void> createUser(FlContent flContent) async => await _service.setData(
        path: APIPath.newCandidate(documentIdFromCurrentDate()),
        data: flContent.toMap(),
      );

  /* Stream<List<FlContent>> flContentsStream() => _service.collectionStream(
    path: APIPath.candidateList(uid),
    builder: (data) => FlContent.fromMap(data),
  );*/

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
