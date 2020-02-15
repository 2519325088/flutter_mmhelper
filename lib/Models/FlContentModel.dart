class FlContent {
  final String education;
  final String email;
  final String gender;

  final String name;
  final String nationality;
  final int order;
  final int parentId;
  final String password;
  final String phone;
  final String religion;
  final String type;
  final String whatsApp;

  FlContent({
    this.education,
    this.email,
    this.gender,

    this.name,
    this.nationality,
    this.order,
    this.parentId,
    this.password,
    this.phone,
    this.religion,
    this.type,
    this.whatsApp,
  });

  factory FlContent.fromMap(Map<String, dynamic> data) => FlContent(
        education: data["education"],
        email: data["email"],
        gender: data["gender"],

        name: data["name"],
        nationality: data["nationality"],
        order: data["order"],
        parentId: data["parentId"],
        password: data["password"],
        phone: data["phone"],
        religion: data["religion"],
        type: data["type"],
        whatsApp: data["whatsApp"],
      );

  Map<String, dynamic> toMap() => {
        "education": education,
        "email": email,
        "gender": gender,

        "name": name,
        "nationality": nationality,
        "order": order,
        "parentId": parentId,
        "password": password,
        "phone": phone,
        "religion": religion,
        "type": type,
        "whatsApp": whatsApp,
      };
}
