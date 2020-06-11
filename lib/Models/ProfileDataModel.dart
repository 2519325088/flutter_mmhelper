// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProfileData profileDataFromJson(String str) =>
    ProfileData.fromMap(json.decode(str));

String profileDataToJson(ProfileData data) => json.encode(data.toMap());

class ProfileData {
  DateTime birthday;
  String children;
  String contract;
  String createdBy;
  String current;
  String education;
  DateTime employment;
  DateTime createTime;
  DateTime updateTime;
  String expectedsalary;
  String firstname;
  String fromAgency;
  String gender;
  String id;
  List<dynamic> imagelist;
  String jobcapacity;
  String jobtype;
  String language;
  String lastname;
  String marital;
  String nationality;
  String phone;
  String countryCodePhone;
  String religion;
  String selfintroduction;
  String whatsapp;
  String countryCodeWhatsapp;
  List<Workexperience> workexperiences;
  String workskill;
  String primaryImage;
  String approved;
  String faceBookId;
  String weight;
  String height;
  String address;
  String userName;
  String status;

  ProfileData(
      {this.birthday,
      this.children,
      this.contract,
      this.createdBy,
      this.current,
      this.education,
      this.employment,
      this.createTime,
      this.updateTime,
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
      this.nationality,
      this.phone,
      this.religion,
      this.selfintroduction,
      this.whatsapp,
      this.workexperiences,
      this.workskill,
      this.primaryImage,
      this.countryCodePhone,
      this.countryCodeWhatsapp,
      this.approved,
      this.faceBookId,
      this.height,
      this.address,
      this.weight,
      this.status,
      this.userName});

  factory ProfileData.fromMap(Map<String, dynamic> json) => ProfileData(
        birthday: json["birthday"] == null
            ? null
            : DateTime.tryParse(json["birthday"]),
        children: json["children"] == null ? null : json["children"],
        approved: json["approved"] == null ? null : json["approved"],
        status: json["status"] == null ? null : json["status"],
        faceBookId: json["facebook_id"] == null ? null : json["facebook_id"],
        contract: json["contract"] == null ? null : json["contract"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        current: json["current"] == null ? null : json["current"],
        education: json["education"] == null ? null : json["education"],
        employment: json["employment"] == null
            ? null
            : DateTime.tryParse(json["employment"]),
        createTime: (!json.containsKey("create_time")) ||
                (json["create_time"] == null) ||
                (json["create_time"] == "")
            ? null
            : (json["create_time"] as Timestamp).toDate(),
        updateTime: (!json.containsKey("update_time")) ||
                (json["update_time"] == null) ||
                (json["update_time"] == "")
            ? null
            : (json["update_time"] as Timestamp).toDate(),
        expectedsalary:
            json["expectedsalary"] == null ? null : json["expectedsalary"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        weight: json["weight"] == null ? null : json["weight"],
        height: json["height"] == null ? null : json["height"],
        address: json["address"] == null ? null : json["address"],
        userName: json["username"] == null ? null : json["username"],
        fromAgency: json["from_agency"] == null ? null : json["from_agency"],
        gender: json["gender"] == null ? null : json["gender"],
        id: json["id"] == null ? null : json["id"],
        imagelist: json["imagelist"] == null
            ? null
            : List<dynamic>.from(json["imagelist"].map((x) => x)),
        jobcapacity: json["jobcapacity"] == null ? null : json["jobcapacity"],
        jobtype: json["jobtype"] == null ? null : json["jobtype"],
        language: json["language"] == null ? null : json["language"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        marital: json["marital"] == null ? null : json["marital"],
        nationality: json["nationaity"] == null ? null : json["nationaity"],
        phone: json["phone"] == null ? null : json["phone"],
        religion: json["religion"] == null ? null : json["religion"],
        selfintroduction:
            json["selfintroduction"] == null ? null : json["selfintroduction"],
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
        workexperiences: json["workexperiences"] == null
            ? null
            : List<Workexperience>.from(
                json["workexperiences"].map((x) => Workexperience.fromMap(x))),
        workskill: json["workskill"] == null ? null : json["workskill"],
        primaryImage:
            json["primaryimage"] == null ? null : json["primaryimage"],
        countryCodePhone:
            json["countryCodePhone"] == null ? null : json["countryCodePhone"],
        countryCodeWhatsapp: json["countryCodeWhatsapp"] == null
            ? null
            : json["countryCodeWhatsapp"],
      );

  Map<String, dynamic> toMap() => {
        "birthday": birthday == null
            ? null
            : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "children": children == null ? null : children,
        "approved": approved == null ? null : approved,
        "status": status == null ? null : status,
        "facebook_id": faceBookId == null ? null : faceBookId,
        "weight": weight == null ? null : weight,
        "height": height == null ? null : height,
        "address": address == null ? null : address,
        "username": userName == null ? null : userName,
        "contract": contract == null ? null : contract,
        "created_by": createdBy == null ? null : createdBy,
        "current": current == null ? null : current,
        "education": education == null ? null : education,
        "employment": employment == null
            ? null
            : "${employment.year.toString().padLeft(4, '0')}-${employment.month.toString().padLeft(2, '0')}-${employment.day.toString().padLeft(2, '0')}",
        "create_time": createTime == null ? null : createTime,
        "update_time": updateTime == null ? null : updateTime,
        "expectedsalary": expectedsalary == null ? null : expectedsalary,
        "firstname": firstname == null ? null : firstname,
        "from_agency": fromAgency == null ? null : fromAgency,
        "gender": gender == null ? null : gender,
        "id": id == null ? null : id,
        "imagelist": imagelist == null
            ? null
            : List<dynamic>.from(imagelist.map((x) => x)),
        "jobcapacity": jobcapacity == null ? null : jobcapacity,
        "jobtype": jobtype == null ? null : jobtype,
        "language": language == null ? null : language,
        "lastname": lastname == null ? null : lastname,
        "marital": marital == null ? null : marital,
        "nationaity": nationality == null ? null : nationality,
        "phone": phone == null ? null : phone,
        "religion": religion == null ? null : religion,
        "selfintroduction": selfintroduction == null ? null : selfintroduction,
        "whatsapp": whatsapp == null ? null : whatsapp,
        "workexperiences": workexperiences == null
            ? null
            : List<dynamic>.from(workexperiences.map((x) => x.toMap())),
        "workskill": workskill == null ? null : workskill,
        "primaryimage": primaryImage == null ? null : primaryImage,
        "countryCodePhone": countryCodePhone == null ? null : countryCodePhone,
        "countryCodeWhatsapp":
            countryCodeWhatsapp == null ? null : countryCodeWhatsapp
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
        end: json["end"] == null || json["end"] == ''
            ? null
            : DateTime.parse(json["end"]),
        jobtype: json["jobtype"] == null ? null : json["jobtype"],
        reason: json["reason"] == null ? null : json["reason"],
        reterence: json["reterence"] == null ? null : json["reterence"],
        start: json["start"] == null || json["start"] == ''
            ? null
            : DateTime.parse(json["start"]),
        taken: json["taken"] == null ? null : json["taken"],
      );

  Map<String, dynamic> toMap() => {
        "country": country == null ? null : country,
        "end": end == null
            ? null
            : "${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}",
        "jobtype": jobtype == null ? null : jobtype,
        "reason": reason == null ? null : reason,
        "reterence": reterence == null ? null : reterence,
        "start": start == null
            ? null
            : "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}",
        "taken": taken == null ? null : taken,
      };
}
