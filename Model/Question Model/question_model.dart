class QuestionModel {
  final String? id;
  final String? questionTitle;
  final List<String>? options;
  final int? answer;
  final String? subjectId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? databaseId;
  final String? collectionId;

  QuestionModel({
    this.id,
    this.questionTitle,
    this.options,
    this.answer,
    this.subjectId,
    this.createdAt,
    this.updatedAt,
    this.databaseId,
    this.collectionId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['\$id'] as String?,
        questionTitle: json['questionTitle'] as String?,
        options: (json['options'] as List<dynamic>?)?.cast<String>(),
        answer: json['answer'] as int?,
        subjectId: json['subject_id'] as String?,
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
        '\$id': id,
        '\$createdAt': createdAt?.toIso8601String(),
        '\$updatedAt': updatedAt?.toIso8601String(),
        '\$databaseId': databaseId,
        '\$collectionId': collectionId,
      };

  // Copy with method to create a copy of this model with potential modifications
  QuestionModel copyWith({
    String? id,
    String? questionTitle,
    List<String>? options,
    int? answer,
    String? subjectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? databaseId,
    String? collectionId,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      questionTitle: questionTitle ?? this.questionTitle,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      subjectId: subjectId ?? this.subjectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      databaseId: databaseId ?? this.databaseId,
      collectionId: collectionId ?? this.collectionId,
    );
  }
}
