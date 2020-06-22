import 'package:cloud_firestore/cloud_firestore.dart';

class TrackContext {
  final String profile_id;
  final String job_id;
  final String signup_id;
  final DateTime created_time;
  String id;


  TrackContext({
    this.profile_id,
    this.job_id,
    this.signup_id,
    this.created_time,
    this.id,
  });

  factory TrackContext.fromMap(Map<String, dynamic> data,
      String documentId) =>
      TrackContext(
        profile_id: data["profile_id"],
        job_id: data["job_id"],
        signup_id: data["signup_id"],
        created_time: data["created_time"],
        id: data["id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "profile_id": profile_id,
        "job_id": job_id,
        "signup_id": signup_id,
        "created_time": created_time,
        "id": id,
      };

}