import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/models/question.dart';
import 'package:quizzy/screens/question_screen.dart';

class WelcomeScreen extends StatelessWidget {
  // Supposez que vous ayez une liste de questions dans votre modèle
  final List<Question> questions = [
    Question(
      text: 'Quelle est la capitale de la France ?',
      answers: [
        Answer(text: 'Berlin', isCorrect: false),
        Answer(text: 'Paris', isCorrect: true),
        Answer(text: 'Londres', isCorrect: false),
        Answer(text: 'Madrid', isCorrect: false),
      ],
    ),
    // Ajoutez d'autres questions ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans l\'application de quiz!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      question: questions[0], // Passer la première question de la liste
                    ),
                  ),
                );
              },
              child: Text('Démarrer le Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
