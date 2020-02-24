class FlImage {
  final String contentType;
  final String file;
  final String folderId;
  final String id;
  final String type;

  FlImage({
    this.contentType,
    this.file,
    this.folderId,
    this.id,
    this.type,
  });

  factory FlImage.fromMap(Map<String, dynamic> json) => FlImage(
    contentType: json["contentType"],
    file: json["file"],
    folderId: json["folderId"],
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toMap() => {
    "contentType": contentType,
    "file": file,
    "folderId": folderId,
    "id": id,
    "type": type,
  };
}