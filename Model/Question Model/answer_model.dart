class AnswerModel {
  final int questionIndex;
  final int selectedOptionIndex;

  AnswerModel({required this.questionIndex, required this.selectedOptionIndex});

  Map<String, dynamic> toJson() {
    return {
      'questionIndex': questionIndex,
      'selectedOptionIndex': selectedOptionIndex,
    };
  }

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      questionIndex: json['questionIndex'],
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }
}

// favorite_question_model.dart
class FavoriteQuestion {
  final int id;
  final String questionTitle;
  final List<String> options;
  final int answer;

  FavoriteQuestion({
    required this.id,
    required this.questionTitle,
    required this.options,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionTitle': questionTitle,
      'options': options,
      'answer': answer,
    };
  }

  factory FavoriteQuestion.fromMap(Map<String, dynamic> map) {
    return FavoriteQuestion(
      id: map['id'],
      questionTitle: map['questionTitle'],
      options: List<String>.from(map['options']),
      answer: map['answer'],
    );
  }
}
