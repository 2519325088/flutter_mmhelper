// To parse this JSON data, do
//
//     final educationList = educationListFromJson(jsonString);

import 'dart:convert';

DataList educationListFromJson(String str) => DataList.fromMap(json.decode(str));

String educationListToJson(DataList data) => json.encode(data.toMap());

class DataList {
  String nameEn;
  String nameZh;

  DataList({
    this.nameEn,
    this.nameZh,
  });

  factory DataList.fromMap(Map<String, dynamic> json) => DataList(
    nameEn: json["name_en"] == null ? null : json["name_en"],
    nameZh: json["name_zh"] == null ? null : json["name_zh"],
  );

  Map<String, dynamic> toMap() => {
    "name_en": nameEn == null ? null : nameEn,
    "name_zh": nameZh == null ? null : nameZh,
  };
}
