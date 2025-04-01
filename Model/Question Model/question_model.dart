class QuestionModel {

  String? questionTitle;


  List<dynamic>? options;


  int? answer;


  String? subjectId;


  String? id;


  DateTime? createdAt;


  DateTime? updatedAt;


  String? databaseId;


  String? collectionId;


  QuestionModel({

    this.questionTitle,

    this.options,

    this.answer,

    this.subjectId,

    this.id,

    this.createdAt,

    this.updatedAt,

    this.databaseId,

    this.collectionId,

  });


  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(

        questionTitle: json['questionTitle'] as String?,

        options: json['options'] as List<dynamic>?,

        answer: json['answer'] as int?,

        subjectId: json['subject_id'] as String?,

        id: json['\$id'] as String?,

        createdAt: json['\$createdAt'] == null

            ? null

            : DateTime.parse(json['\$createdAt'] as String),

        updatedAt: json['\$updatedAt'] == null

            ? null

            : DateTime.parse(json['\$updatedAt'] as String),

        databaseId: json['\$databaseId'] as String?,

        collectionId: json['\$collectionId'] as String?,

      );


  Map<String, dynamic> toJson() => {

        'questionTitle': questionTitle,

        'options': options,

        'answer': answer,

        'subject_id': subjectId,

        '$id': id,

        '$createdAt': createdAt?.toIso8601String(),

        '$updatedAt': updatedAt?.toIso8601String(),

        '$databaseId': databaseId,

        '$collectionId': collectionId,

      };

}

