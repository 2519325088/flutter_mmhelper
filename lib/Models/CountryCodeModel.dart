// To parse this JSON data, do
//
//     final countryCode = countryCodeFromJson(jsonString);

import 'dart:convert';

List<CountryCode> countryCodeFromJson(String str) => List<CountryCode>.from(json.decode(str).map((x) => CountryCode.fromJson(x)));

String countryCodeToJson(List<CountryCode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryCode {
  final String name;
  final String dialCode;
  final String code;

  CountryCode({
    this.name,
    this.dialCode,
    this.code,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
    name: json["name"] == null ? null : json["name"],
    dialCode: json["dial_code"] == null ? null : json["dial_code"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "dial_code": dialCode == null ? null : dialCode,
    "code": code == null ? null : code,
  };
}
