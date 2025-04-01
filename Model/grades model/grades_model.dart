class GradeModel {
  final String? id;
  final String? gradeName;
  final String? gradePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? permissions;
  final String? databaseId;
  final String? collectionId;

  GradeModel({
    this.id,
    this.gradeName,
    this.gradePicture,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) => GradeModel(
        id: json['\$id'] as String?,
        gradeName: json['grade_name'] as String?,
        gradePicture: json['grade_picture'] as String?,
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
        'grade_name': gradeName,
        'grade_picture': gradePicture,
        '\$id': id,
        '\$createdAt': createdAt?.toIso8601String(),
        '\$updatedAt': updatedAt?.toIso8601String(),
        '\$permissions': permissions,
        '\$databaseId': databaseId,
        '\$collectionId': collectionId,
      };
}
