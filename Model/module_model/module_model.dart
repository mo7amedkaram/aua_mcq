class ModuleModel {
  String? moduleName;
  String? moduleImage;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? permissions;
  String? databaseId;
  String? collectionId;

  ModuleModel({
    this.moduleName,
    this.moduleImage,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.permissions,
    this.databaseId,
    this.collectionId,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) => ModuleModel(
        moduleName: json['module_name'] as String?,
        moduleImage: json['module_image'] as String?,
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
        'module_name': moduleName,
        'module_image': moduleImage,
        '$id': id,
        '$createdAt': createdAt?.toIso8601String(),
        '$updatedAt': updatedAt?.toIso8601String(),
        '$permissions': permissions,
        '$databaseId': databaseId,
        '$collectionId': collectionId,
      };

}

