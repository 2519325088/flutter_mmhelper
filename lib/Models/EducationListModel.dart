// To parse this JSON data, do
//
//     final educationList = educationListFromJson(jsonString);

import 'dart:convert';

EducationList educationListFromJson(String str) => EducationList.fromMap(json.decode(str));

String educationListToJson(EducationList data) => json.encode(data.toMap());

class EducationList {
  String nameEn;
  String nameZh;

  EducationList({
    this.nameEn,
    this.nameZh,
  });

  factory EducationList.fromMap(Map<String, dynamic> json) => EducationList(
    nameEn: json["name_en"] == null ? null : json["name_en"],
    nameZh: json["name_zh"] == null ? null : json["name_zh"],
  );

  Map<String, dynamic> toMap() => {
    "name_en": nameEn == null ? null : nameEn,
    "name_zh": nameZh == null ? null : nameZh,
  };
}
