class SubjectModel {
  String? subjectName;
  String? moduleId;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? permissions;
  String? databaseId;
  String? collectionId;

  SubjectModel({
    this.subjectName,
    this.moduleId,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        subjectName: json['subject_name'] as String?,
        moduleId: json['module_id'] as String?,
        id: json['\$id'] as String?,
        createdAt: json['\$createdAt'] == null
            ? null
            : DateTime.parse(json['\$createdAt'] as String),
        updatedAt: json['\$updatedAt'] == null
            ? null
            : DateTime.parse(json['\$updatedAt'] as String),
        permissions: json['\$permissions'] as List<dynamic>?,
        databaseId: json['\$databaseId'] as String?,
        collectionId: json['\$collectionId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'subject_name': subjectName,
        'module_id': moduleId,
        '$id': id,
        '$createdAt': createdAt?.toIso8601String(),
        '$updatedAt': updatedAt?.toIso8601String(),
        '$permissions': permissions,
        '$databaseId': databaseId,
        '$collectionId': collectionId,
      };

}

