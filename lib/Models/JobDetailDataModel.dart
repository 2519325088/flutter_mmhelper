// To parse this JSON data, do
//
//     final jobDetailData = jobDetailDataFromJson(jsonString);

import 'dart:convert';

JobDetailData jobDetailDataFromJson(String str) => JobDetailData.fromMap(json.decode(str));

String jobDetailDataToJson(JobDetailData data) => json.encode(data.toMap());

class JobDetailData {
  String accommodation;
  DateTime available;
  String contractType;
  String currencyType;
  String id;
  String jobShortDescription;
  String jobType;
  String moreDescription;
  String salary;
  String skillRequirement;
  String unitSize;
  String userId;
  String weeklyHoliday;
  String workingLocation;

  JobDetailData({
    this.accommodation,
    this.available,
    this.contractType,
    this.currencyType,
    this.id,
    this.jobShortDescription,
    this.jobType,
    this.moreDescription,
    this.salary,
    this.skillRequirement,
    this.unitSize,
    this.userId,
    this.weeklyHoliday,
    this.workingLocation,
  });

  factory JobDetailData.fromMap(Map<String, dynamic> json) => JobDetailData(
    accommodation: json["accommodation"] == null ? null : json["accommodation"],
    available: json["available"] == null || json["available"] == '' ? null : DateTime.parse(json["available"]),
    contractType: json["contract_type"] == null ? null : json["contract_type"],
    currencyType: json["currencyType"] == null ? null : json["currencyType"],
    id: json["id"] == null ? null : json["id"],
    jobShortDescription: json["job_short_description"] == null ? null : json["job_short_description"],
    jobType: json["job_type"] == null ? null : json["job_type"],
    moreDescription: json["more_description"] == null ? null : json["more_description"],
    salary: json["salary"] == null ? null : json["salary"],
    skillRequirement: json["skill_requirement"] == null ? null : json["skill_requirement"],
    unitSize: json["unit_size"] == null ? null : json["unit_size"],
    userId: json["user_id"] == null ? null : json["user_id"],
    weeklyHoliday: json["weekly_holiday"] == null ? null : json["weekly_holiday"],
    workingLocation: json["working_location"] == null ? null : json["working_location"],
  );

  Map<String, dynamic> toMap() => {
    "accommodation": accommodation == null ? null : accommodation,
    "available": available == null ? null : available.toIso8601String(),
    "contract_type": contractType == null ? null : contractType,
    "currencyType": currencyType == null ? null : currencyType,
    "id": id == null ? null : id,
    "job_short_description": jobShortDescription == null ? null : jobShortDescription,
    "job_type": jobType == null ? null : jobType,
    "more_description": moreDescription == null ? null : moreDescription,
    "salary": salary == null ? null : salary,
    "skill_requirement": skillRequirement == null ? null : skillRequirement,
    "unit_size": unitSize == null ? null : unitSize,
    "user_id": userId == null ? null : userId,
    "weekly_holiday": weeklyHoliday == null ? null : weeklyHoliday,
    "working_location": workingLocation == null ? null : workingLocation,
  };
}
