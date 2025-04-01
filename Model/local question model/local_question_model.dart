import 'dart:convert';

class LocalQuestion {
  final int id;
  final String questionTitle;
  final List<dynamic> options;
  final int answer;

  LocalQuestion({
    required this.id,
    required this.questionTitle,
    required this.options,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionTitle': questionTitle,
      'options': json.encode(options),
      'answer': answer,
    };
  }

  factory LocalQuestion.fromMap(Map<String, dynamic> map) {
    return LocalQuestion(
      id: map['id'],
      questionTitle: map['questionTitle'],
      options: json.decode(map['options']),
      answer: map['answer'],
    );
  }
}
