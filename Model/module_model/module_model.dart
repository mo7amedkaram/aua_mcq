class ModuleModel {
  final String? id;
  final String? moduleName;
  final String? moduleImage;
  final String? gradeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic>? permissions;
  final String? databaseId;
  final String? collectionId;

  ModuleModel({
    this.id,
    this.moduleName,
    this.moduleImage,
    this.gradeId,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
        id: json['\$id'] as String?,
        moduleName: json['module_name'] as String?,
        moduleImage: json['module_image'] as String?,
        gradeId: json['grade_id'] as String?,
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
        'module_name': moduleName,
        'module_image': moduleImage,
        'grade_id': gradeId,
        '\$id': id,
        '\$createdAt': createdAt?.toIso8601String(),
        '\$updatedAt': updatedAt?.toIso8601String(),
        '\$permissions': permissions,
        '\$databaseId': databaseId,
        '\$collectionId': collectionId,
      };
}
