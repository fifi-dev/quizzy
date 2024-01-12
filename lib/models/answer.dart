class Answer {
  String text;
  bool isCorrect;

  Answer({required this.text, required this.isCorrect});

  // Add toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}
