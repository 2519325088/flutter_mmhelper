class QuestionResultContext {
  String ID;
  String answer;
  String profile_id;
  String question_id;
  String documentId;

  QuestionResultContext({
    this.ID,
    this.answer,
    this.profile_id,
    this.question_id,
    this.documentId,
  });

  factory QuestionResultContext.fromMap(
          Map<String, dynamic> data, String documentId) =>
      QuestionResultContext(
        ID: data["ID"],
        answer: data["answer"],
        profile_id: data["profile_id"],
        question_id: data["question_id"],
        documentId: documentId,
      );

  Map<String, dynamic> toMap() => {
        "ID": ID,
        "answer": answer,
        "profile_id": profile_id,
        "question_id": question_id,
      };
}
