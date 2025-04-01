class Answer {
  final int questionIndex;
  final int selectedOptionIndex;

  Answer({required this.questionIndex, required this.selectedOptionIndex});

  Map<String, dynamic> toJson() {
    return {
      'questionIndex': questionIndex,
      'selectedOptionIndex': selectedOptionIndex,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionIndex: json['questionIndex'],
      selectedOptionIndex: json['selectedOptionIndex'],
    );
  }
}
