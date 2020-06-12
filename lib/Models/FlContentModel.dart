import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FlContent {
  //final List<ImageDeck> imageDeck;
  final String education;
  final String email;
  final String gender;
  final String profileImageUrl;
  final String lastname;
  final String firstname;
  final String username;
  final String role;
  final String nationality;
  final int order;
  final int parentId;
  final String password;
  final String phone;
  final String religion;
  final String type;
  final String whatsApp;
  final String id;
  final String countryCode;
  String userId;

  FlContent({
    //this.imageDeck,
    this.education,
    this.email,
    this.gender,
    this.profileImageUrl,
    this.lastname,
    this.firstname,
    this.username,
    this.role,
    this.nationality,
    this.order,
    this.parentId,
    this.password,
    this.phone,
    this.religion,
    this.type,
    this.whatsApp,
    this.id,
    this.userId,
    this.countryCode,
  });

  factory FlContent.fromMap(Map<String, dynamic> data) =>
      FlContent(
       // imageDeck: List<ImageDeck>.from(
       //     data["imageDeck"].map((x) => ImageDeck.fromMap(x))),
        education: data["education"],
        email: data["email"],
        gender: data["gender"],
        profileImageUrl: data["profileImageUrl"],
        lastname: data["lsatname"],
        firstname: data["firstname"],
        username: data["username"],
        role: data["role"],
        nationality: data["nationality"],
        order: data["order"],
        parentId: data["parentId"],
        password: data["password"],
        phone: data["phone"],
        religion: data["religion"],
        type: data["type"],
        whatsApp: data["whatsApp"],
        userId: data["userId"],
        countryCode: data["countryCode"],
      );

  Map<String, dynamic> toMap() => {
        "education": education,
        "email": email,
        "gender": gender,
        "profileImageUrl": profileImageUrl,
        "lastname": lastname,
        "firstname": firstname,
        "username": username,
        "role": role,
        "nationality": nationality,
        "order": order,
        "parentId": parentId,
        "password": password,
        "phone": phone,
        "religion": religion,
        "type": type,
        "whatsApp": whatsApp,
        "userId": userId,
        "countryCode": countryCode,
      };
}

class ImageDeck with ChangeNotifier {
  final String description;
  final List<dynamic> image;
  List<String> imageUrl = [];
  final String title;
  final String uniqueKey;

  ImageDeck({
    this.description,
    this.image,
    this.imageUrl,
    this.title,
    this.uniqueKey,
  });

  factory ImageDeck.fromMap(Map<dynamic, dynamic> json) => ImageDeck(
        description: json["description"],
        image: List<dynamic>.from(json["image"].map((x) => x)),
        imageUrl: List<String>.from(json["image"].map((x) {
          return x.toString();
        })),
        title: json["title"],
        uniqueKey: json["uniqueKey"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "image": List<dynamic>.from(image.map((x) => x)),
        "title": title,
        "uniqueKey": uniqueKey,
      };
}
