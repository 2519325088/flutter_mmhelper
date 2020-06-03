// To parse this JSON data, do
//
//     final postJob = postJobFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class PostJob {
  String id;
  String userId;
  String jobShortDescription;
  String contractType;
  String workingLocation;
  String jobType;
  DateTime available;
  DateTime availableTime;
  String currencyType;
  String salary;
  String unitSize;
  String accommodation;
  String weeklyHoliday;
  String moreDescription;
  String skillRequirement;

  PostJob(
      {this.id,
      this.userId,
      this.jobShortDescription,
      this.contractType,
      this.workingLocation,
      this.jobType,
      this.available,
      this.currencyType,
      this.salary,
      this.unitSize,
      this.accommodation,
      this.weeklyHoliday,
      this.moreDescription,
      this.skillRequirement,
      this.availableTime});

  factory PostJob.fromMap(Map<String, dynamic> json) => PostJob(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        jobShortDescription: json["job_short_description"] == null
            ? null
            : json["job_short_description"],
        contractType:
            json["contract_type"] == null ? null : json["contract_type"],
        workingLocation:
            json["working_location"] == null ? null : json["working_location"],
        jobType: json["job_type"] == null ? null : json["job_type"],
        available: json["available"] == null || json["available"] == ''
            ? null
            : DateTime.parse(json["available"]),
        availableTime:
            json["available_time"] == null || json["available_time"] == ''
                ? null
                : DateTime.parse(json["available_time"]),
        currencyType:
            json["currencyType"] == null ? null : json["currencyType"],
        salary: json["salary"] == null ? null : json["salary"],
        unitSize: json["unit_size"] == null ? null : json["unit_size"],
        accommodation:
            json["accommodation"] == null ? null : json["accommodation"],
        weeklyHoliday:
            json["weekly_holiday"] == null ? null : json["weekly_holiday"],
        moreDescription:
            json["more_description"] == null ? null : json["more_description"],
        skillRequirement: json["skill_requirement"] == null
            ? null
            : json["skill_requirement"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "job_short_description":
            jobShortDescription == null ? null : jobShortDescription,
        "contract_type": contractType == null ? null : contractType,
        "working_location": workingLocation == null ? null : workingLocation,
        "job_type": jobType == null ? null : jobType,
        "available": available == null ? null : available.toIso8601String(),
        "currencyType": currencyType == null ? null : currencyType,
        "salary": salary == null ? null : salary,
        "unit_size": unitSize == null ? null : unitSize,
        "accommodation": accommodation == null ? null : accommodation,
        "weekly_holiday": weeklyHoliday == null ? null : weeklyHoliday,
        "more_description": moreDescription == null ? null : moreDescription,
        "skill_requirement": skillRequirement == null ? null : skillRequirement,
        "available_time": availableTime == null ? null : availableTime,
      };
}
