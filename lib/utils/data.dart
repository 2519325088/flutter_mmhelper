import 'dart:math';
import 'package:flutter_mmhelper/ui/widgets/profilechild/children.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/education.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/marital.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/religion.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/job_type.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/job_capacity.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/contract.dart';

Random random = Random();

List names = [
  "Ling Waldner",
  "Gricelda Barrera",
  "Lenard Milton",
  "Bryant Marley",
  "Rosalva Sadberry",
  "Guadalupe Ratledge",
  "Brandy Gazda",
  "Kurt Toms",
  "Rosario Gathright",
  "Kim Delph",
  "Stacy Christensen",
];

List roles = [
  "Employer",
  "Foreign Helper (Filipion/Indonesian...)",
  "Local Auntie (Chinese)",
];

List education =[
  "Elementary",
  "Junior High School",
  "Senior High School",
  "University",
];

List detailltitle =[
  "Education",
  "Religion",
  "Marital Status",
  "Children",
  "Current Location",
];
List detailltext=[
  "Select",
  "Select",
  "Select",
  "Select",
  "Select",
];

List work = [
  "Job Type",
  "Job Capacity",
  "Contract Status",
  "Working Skills",
  "Languages",
];

List religion = [
  "Christian",
  "Moslem",
  "Buddhist",
  "Othiers",
];

List marital =[
  "Single",
  "Married",
  "Divorced",
  "Widowed",
  "Separated",
];

List children=[
  "0",
  "1",
  "2",
  "3",
  ">3",
];

List jobtype=[
  "Domestic Helper",
  "Driver",
];

List jobcapacity=[
  "Full Time",
  "Part Time",
];

List contract=[
  "Finished",
  "Terminated",
  "Break",
  "Employed",
  "Ex-HK",
  "Ex-Overseas",
  "First Time Overseas",
];

List gender = [
  "Male",
  "Female",
];


List pagename = [
  Education(),
  Religion(),
  Marital(),
  ChildrenPage(),
  Religion(),
];

List workoage=[
  JobType(),
  JobCapacity(),
  Contract(),
  JobType(),
  JobType(),
];

List roleds = List.generate(3, (index)=>{
  "name": roles[index],
});

List educations = List.generate(4, (index)=>{
  "name": education[index],
});

List detaills =List.generate(5, (index)=>{
  "title": detailltitle[index],
  "text": detailltext[index],
  "page":pagename[index],
});

List religions = List.generate(4, (index)=>{
  "name": religion[index],
});

List maritals = List.generate(5, (index)=>{
  "name": marital[index],
});

List childrens = List.generate(5, (index)=>{
  "name": children[index],
});

List works =List.generate(5, (index)=>{
  "title": work[index],
  "text": "Select",
  "page":workoage[index],
});

List jobtypes =List.generate(2, (index)=>{
  "name": jobtype[index],
});

List jobcapacitys =List.generate(2, (index)=>{
  "name": jobcapacity[index],
});

List contracts =List.generate(7, (index)=>{
  "name": contract[index],
});

List genders =List.generate(2, (index)=>{
  "name": gender[index],
});