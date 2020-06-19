import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteContext {
  final String employer_id;
  String id;
  final String profile_id;


  FavouriteContext({
    this.employer_id,
    this.id,
    this.profile_id,
  });

  factory FavouriteContext.fromMap(Map<String, dynamic> data,) =>
      FavouriteContext(
        employer_id: data["employer_id"],
        id: data["id"],
        profile_id: data["profile_id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "employer_id": employer_id,
        "id": id,
        "profile_id": profile_id,

      };

}