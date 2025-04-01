class SubjectModel {
  final String? id;
  final String? subjectName;
  final String? moduleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? permissions;
  final String? databaseId;
  final String? collectionId;

  SubjectModel({
    this.id,
    this.subjectName,
    this.moduleId,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        id: json['\$id'] as String?,
        subjectName: json['subject_name'] as String?,
        moduleId: json['module_id'] as String?,
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
        '\$id': id,
        '\$createdAt': createdAt?.toIso8601String(),
        '\$updatedAt': updatedAt?.toIso8601String(),
        '\$permissions': permissions,
        '\$databaseId': databaseId,
        '\$collectionId': collectionId,
      };
}
