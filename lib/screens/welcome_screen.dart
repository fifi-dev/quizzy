import 'package:flutter/material.dart';
import 'package:quizzy/screens/question_screen.dart';
import 'package:quizzy/models/question.dart'; // Assurez-vous d'importer correctement le modèle de question

class WelcomeScreen extends StatelessWidget {
  final List<Question> questions; // Ajoutez une liste de questions

  WelcomeScreen({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans l\'application Quizzy !',
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
                      questions: questions, // Passez la liste complète de questions
                    ),
                  ),
                );
              },
              child: Text('Démarrer'),
            ),
          ],
        ),
      ),
    );
  }
}
