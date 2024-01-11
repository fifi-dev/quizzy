import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/models/question.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questions;
  QuestionScreen({required this.questions});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  int score = 0;
  Answer? selectedAnswer;

  void goToNextQuestion() {
    setState(() {
      if (currentIndex < widget.questions.length - 1) {
        currentIndex++;
      } else {
        // Affichez le résultat final si toutes les questions ont été répondues
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
      // Réinitialisez la réponse sélectionnée pour la nouvelle question
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentIndex + 1}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.questions[currentIndex].text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            // Affichez les options de réponse ici
            Column(
              children: widget.questions[currentIndex].answers.map((answer) {
                return RadioListTile<Answer>(
                  title: Text(answer.text),
                  value: answer,
                  groupValue: selectedAnswer,
                  onChanged: (Answer? value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedAnswer != null) {
                  // Évaluez la réponse et mettez à jour le score
                  if (selectedAnswer!.isCorrect) {
                    score += 10; // Ajoutez le score en fonction de votre logique
                  }
                  goToNextQuestion(); // Passez à la prochaine question
                }
              },
              child: Text('Valider la Réponse'),
            ),
          ],
        ),
      ),
    );
  }
}
