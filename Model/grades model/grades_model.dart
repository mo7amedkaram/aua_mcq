class GradesModel {

  String? gradeName;


  String? gradePicture;


  String? id;


  DateTime? createdAt;


  DateTime? updatedAt;


  List<dynamic>? permissions;


  String? databaseId;


  String? collectionId;


  GradesModel({

    this.gradeName,

    this.gradePicture,

    this.id,

    this.createdAt,

    this.updatedAt,

    this.permissions,

    this.databaseId,

    this.collectionId,

  });


  factory GradesModel.fromJson(Map<String, dynamic> json) => GradesModel(

        gradeName: json['grade_name'] as String?,

        gradePicture: json['grade_picture'] as String?,

        id: json['\$id'] as String?,

      );


  Map<String, dynamic> toJson() => {

        'grade_name': gradeName,

        'grade_picture': gradePicture,

        '$id': id,

      };

}

