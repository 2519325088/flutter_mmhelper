// To parse this JSON data, do
//
//     final dataList = dataListFromJson(jsonString);

import 'dart:convert';

DataList dataListFromJson(String str) => DataList.fromMap(json.decode(str));

String dataListToJson(DataList data) => json.encode(data.toMap());

class DataList {
  String nameEn;
  String nameZh;
  String nameId;

  DataList({
    this.nameEn,
    this.nameZh,
    this.nameId,
  });

  factory DataList.fromMap(Map<String, dynamic> json) => DataList(
        nameEn: json["name_en"] == null ? null : json["name_en"],
        nameZh: json["name_zh"] == null ? null : json["name_zh"],
        nameId: json["name_id"] == null ? null : json["name_id"],
      );

  Map<String, dynamic> toMap() => {
        "name_en": nameEn == null ? null : nameEn,
        "name_zh": nameZh == null ? null : nameZh,
        "name_id": nameId == null ? null : nameId,
      };

  String getValueByLanguageCode(String languageCode) {
    return languageCode == "en" ? nameEn : nameZh;
  }
}
