import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data); //i think this is error
  }

  Future<void> addData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.collection(path);
    print('$path: $data');
    await reference.add(data); //i think this is errorzz
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) {
          return builder(snapshot.data, snapshot.documentID);
        }).toList());
  }

  Stream<List<T>> jobCollectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    final reference =
        Firestore.instance.collection(path).orderBy('id', descending: true);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) {
          return builder(snapshot.data, snapshot.documentID);
        }).toList());
  }
}
