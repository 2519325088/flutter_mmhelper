// To parse this JSON data, do
//
//     final facebookdata = facebookdataFromJson(jsonString);

import 'dart:convert';

Facebookdata facebookdataFromJson(String str) => Facebookdata.fromJson(json.decode(str));

String facebookdataToJson(Facebookdata data) => json.encode(data.toJson());

class Facebookdata {
  String name;
  String firstName;
  String lastName;
  String email;
  String id;

  Facebookdata({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  factory Facebookdata.fromJson(Map<String, dynamic> json) => new Facebookdata(
    name: json["name"] == null ? null : json["name"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "id": id == null ? null : id,
  };
}
