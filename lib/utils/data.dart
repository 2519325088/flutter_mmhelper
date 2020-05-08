import 'dart:math';
import 'package:flutter_mmhelper/ui/widgets/profilechild/children.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/education.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/marital.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/religion.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/work_skill.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/languages.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/curren_location.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/work_country.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/taken_care.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/reference.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/quit_reason.dart';
import 'package:flutter_mmhelper/ui/widgets/profilechild/workchild/work_job.dart';


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

List username =[
  "Mama",
  "Helpers",
  "Select",
  "Select",
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

List whatapptext=[
  "+85263433995",
  "+85263433995",
];

List worktop=[
  "Job Type",
  "Job Capacity",
  "Contract Status",
];

List worktopdata=[
  "Select",
  "Select",
  "Select",
];

List work = [
  "Working Skills",
  "Languages",
  "Work Experiences",
];

List workend =[
  "ExpectedSalary(HKD)",
  "Employment Start Date",
];

List worktexts =[
  "Select",
  "Select",
  "No information",
  "",
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

List takencare=[
  "0",
  "1",
  "2",
  "3",
  "4",
  ">4",
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

List texttags =[
  "Western Food",
  "Chinese Food",
  "Japanese Food",
  "Indian Food",
  "Care New-born",
  "Care Todlers",
  "Care Kids",
  "Care Elderly",
  "Care Disabled",
  "Care Pets",
  "Marketing",
  "Car Washing",
  "Driving",
  "Ironing",
  "Tutoring",
];
List datatag=[];

List language=[
  "English",
  "Cantonese",
  "Mandarin",
];

String datatimes="Select";

List datalanguage=[];

List addwork=[
  "Country",
  "Start Date",
  "End Date",
  "Type of Jobs",
  "Number of Taken Care",
  "Quit Reason",
  "Reterence Letter",
];

List addworktext=[
  "Select",
  "Select",
  "Select",
  "Select",
  "Select",
  "Select",
  "Select",
];

List quitreason=[
  "Finished Contract",
  "Family Relocation",
  "Others",
];

List reference=[
  "No",
  "Yes",
];

List workhistory=[];

List pagename = [
  Education(),
  Religion(),
  Marital(),
  ChildrenPage(),
  CurrentLocation(),
];

List workoage=[
//  JobType(),
//  JobCapacity(),
//  Contract(),
  WorkSkill(),
  LanguagePage(langtag:detaills[4]["text"],),
];

List workpage=[
  WorkCountry(),
  "startdate",
  "enddate",
  WorkJobType(),
  TakenCare(),
  QuitReason(),
  Reference(),
];

List imageList=[];


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

List takencares = List.generate(6, (index)=>{
  "name": takencare[index],
});

List works =List.generate(2, (index)=>{
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

List addworks =List.generate(7, (index)=>{
  "title": addwork[index],
  "text":addworktext[index],
  "page":workpage[index],
});

List quitreasons = List.generate(3, (index)=>{
  "name": quitreason[index],
});

List references = List.generate(2, (index)=>{
  "name": reference[index],
});


List apptitle =[
  "Submitted",
  "Paid",
  "Preparing",
  "Documents ready",
  "Processing of working visa",
  "Working Visa Active ",
  "Arrival in HK",
];

List apptext = [
  "Application details have been sent to the agency. They will contact you and your helper to confirm the eligibility for paper processing.",
  "Your are required to pay to our recommended accredited agencies directly (NO transaction is allowed in the APP at this moment)",
  "The physical copy will be collected by the accredited agencies as well. The agency will prepare all the documents for your helper to sign and mail them to your address for you to sign as well. ",
  "Please mail back the all required physical documents to the agency.",
  "Agency received all documents and notarizate the contract from Philippine Consulate and verifiy with the Hong Kong Immigration Department",
  "After working visa approved, we will arrange OEC and arrival in Hong Kong",
  "After working visa approved, we will arrange OEC and arrival in Hong Kong",
];

List applications = List.generate(7, (index)=>{
  "title":apptitle[index],
  "text": apptext[index],
});

