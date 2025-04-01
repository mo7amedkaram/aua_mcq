import 'dart:convert';

class Question {
  final int id; // إضافة خاصية الهوية
  final String questionTitle;
  final List<dynamic> options;
  final int answer;

  Question(
      {required this.id,
      required this.questionTitle,
      required this.options,
      required this.answer});

  Map<String, dynamic> toMap() {
    return {
      'id': id, // تأكد من تضمين الـ id هنا أيضاً
      'questionTitle': questionTitle,
      'options': json.encode(options),
      'answer': answer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      questionTitle: map['questionTitle'],
      options: json.decode(map['options']),
      answer: map['answer'],
    );
  }
}
