import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_mmhelper/Models/FlContentModel.dart';
import 'package:meta/meta.dart';

import 'api_path.dart';
import 'firestore_service.dart';



String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase  with ChangeNotifier{
  /*FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
*/
  final _service = FirestoreService.instance;

  Future<void> createUser(FlContent flContent) async => await _service.setData(
        path: APIPath.newCandidate(documentIdFromCurrentDate()),
        data: flContent.toMap(),
      );

 /* Stream<List<FlContent>> flContentsStream() => _service.collectionStream(
    path: APIPath.candidateList(uid),
    builder: (data) => FlContent.fromMap(data),
  );*/

}
