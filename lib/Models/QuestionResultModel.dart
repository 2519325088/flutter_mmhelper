import 'package:cloud_firestore/cloud_firestore.dart';

class   QuestionResultContext {
  final String ID;
  final String answer;
  final String profile_id;
  final String question_id;


  QuestionResultContext({
    this.ID,
    this.answer,
    this.profile_id,
    this.question_id,
  });

  factory QuestionResultContext.fromMap(Map<String, dynamic> data,
      String documentId) =>
      QuestionResultContext(
        ID: data["ID"],
        answer: data["answer"],
        profile_id: data["profile_id"],
        question_id: data["question_id"],
      );

  Map<String, dynamic> toMap() =>
      {
        "ID": ID,
        "answer": answer,
        "profile_id": profile_id,
        "question_id": question_id,
      };

}