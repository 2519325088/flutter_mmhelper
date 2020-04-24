// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

ProfileData profileDataFromJson(String str) => ProfileData.fromMap(json.decode(str));

String profileDataToJson(ProfileData data) => json.encode(data.toMap());

class ProfileData {
  DateTime birthday;
  String children;
  String contract;
  String createdBy;
  String current;
  String education;
  DateTime employment;
  String expectedsalary;
  String firstname;
  String fromAgency;
  String gender;
  DateTime id;
  List<dynamic> imagelist;
  String jobcapacity;
  String jobtype;
  String language;
  String lastname;
  String marital;
  String nationaity;
  String phone;
  String religion;
  String selfintroduction;
  String whatsapp;
  List<Workexperience> workexperiences;
  String workskill;
  String primaryImage;

  ProfileData({
    this.birthday,
    this.children,
    this.contract,
    this.createdBy,
    this.current,
    this.education,
    this.employment,
    this.expectedsalary,
    this.firstname,
    this.fromAgency,
    this.gender,
    this.id,
    this.imagelist,
    this.jobcapacity,
    this.jobtype,
    this.language,
    this.lastname,
    this.marital,
    this.nationaity,
    this.phone,
    this.religion,
    this.selfintroduction,
    this.whatsapp,
    this.workexperiences,
    this.workskill,
    this.primaryImage,
  });

  factory ProfileData.fromMap(Map<String, dynamic> json) => ProfileData(
    birthday: json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
    children: json["children"] == null ? null : json["children"],
    contract: json["contract"] == null ? null : json["contract"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    current: json["current"] == null ? null : json["current"],
    education: json["education"] == null ? null : json["education"],
    employment: json["employment"] == null ? null : DateTime.parse(json["employment"]),
    expectedsalary: json["expectedsalary"] == null ? null : json["expectedsalary"],
    firstname: json["firstname"] == null ? null : json["firstname"],
    fromAgency: json["from_agency"] == null ? null : json["from_agency"],
    gender: json["gender"] == null ? null : json["gender"],
    id: json["id"] == null ? null : DateTime.parse(json["id"]),
    imagelist: json["imagelist"] == null ? null : List<dynamic>.from(json["imagelist"].map((x) => x)),
    jobcapacity: json["jobcapacity"] == null ? null : json["jobcapacity"],
    jobtype: json["jobtype"] == null ? null : json["jobtype"],
    language: json["language"] == null ? null : json["language"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    marital: json["marital"] == null ? null : json["marital"],
    nationaity: json["nationaity"] == null ? null : json["nationaity"],
    phone: json["phone"] == null ? null : json["phone"],
    religion: json["religion"] == null ? null : json["religion"],
    selfintroduction: json["selfintroduction"] == null ? null : json["selfintroduction"],
    whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
    workexperiences: json["workexperiences"] == null ? null : List<Workexperience>.from(json["workexperiences"].map((x) => Workexperience.fromMap(x))),
    workskill: json["workskill"] == null ? null : json["workskill"],
    primaryImage: json["primaryimage"] == null ? null : json["primaryimage"],
  );

  Map<String, dynamic> toMap() => {
    "birthday": birthday == null ? null : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "children": children == null ? null : children,
    "contract": contract == null ? null : contract,
    "created_by": createdBy == null ? null : createdBy,
    "current": current == null ? null : current,
    "education": education == null ? null : education,
    "employment": employment == null ? null : "${employment.year.toString().padLeft(4, '0')}-${employment.month.toString().padLeft(2, '0')}-${employment.day.toString().padLeft(2, '0')}",
    "expectedsalary": expectedsalary == null ? null : expectedsalary,
    "firstname": firstname == null ? null : firstname,
    "from_agency": fromAgency == null ? null : fromAgency,
    "gender": gender == null ? null : gender,
    "id": id == null ? null : id.toIso8601String(),
    "imagelist": imagelist == null ? null : List<dynamic>.from(imagelist.map((x) => x)),
    "jobcapacity": jobcapacity == null ? null : jobcapacity,
    "jobtype": jobtype == null ? null : jobtype,
    "language": language == null ? null : language,
    "lastname": lastname == null ? null : lastname,
    "marital": marital == null ? null : marital,
    "nationaity": nationaity == null ? null : nationaity,
    "phone": phone == null ? null : phone,
    "religion": religion == null ? null : religion,
    "selfintroduction": selfintroduction == null ? null : selfintroduction,
    "whatsapp": whatsapp == null ? null : whatsapp,
    "workexperiences": workexperiences == null ? null : List<dynamic>.from(workexperiences.map((x) => x.toMap())),
    "workskill": workskill == null ? null : workskill,
    "primaryimage": primaryImage == null ? null : primaryImage,
  };
}

class Workexperience {
  String country;
  DateTime end;
  String jobtype;
  String reason;
  String reterence;
  DateTime start;
  String taken;

  Workexperience({
    this.country,
    this.end,
    this.jobtype,
    this.reason,
    this.reterence,
    this.start,
    this.taken,
  });

  factory Workexperience.fromMap(Map<String, dynamic> json) => Workexperience(
    country: json["country"] == null ? null : json["country"],
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    jobtype: json["jobtype"] == null ? null : json["jobtype"],
    reason: json["reason"] == null ? null : json["reason"],
    reterence: json["reterence"] == null ? null : json["reterence"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    taken: json["taken"] == null ? null : json["taken"],
  );

  Map<String, dynamic> toMap() => {
    "country": country == null ? null : country,
    "end": end == null ? null : "${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}",
    "jobtype": jobtype == null ? null : jobtype,
    "reason": reason == null ? null : reason,
    "reterence": reterence == null ? null : reterence,
    "start": start == null ? null : "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}",
    "taken": taken == null ? null : taken,
  };
}
