import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/screens/welcome_screen.dart';
import 'package:quizzy/models/question.dart'; // Assurez-vous d'importer correctement le modèle de question

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Créez une liste de questions (remplacez ceci par votre propre liste)
    List<Question> questions = [
      Question(
        text: 'Quelle est la capitale de la France?',
        answers: [
          Answer(text: 'Berlin', isCorrect: false),
          Answer(text: 'Londres', isCorrect: false),
          Answer(text: 'Paris', isCorrect: true),
          Answer(text: 'Madrid', isCorrect: false),
        ],
      ),
      // Ajoutez d'autres questions ici...
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(questions: questions), // Passez la liste de questions à WelcomeScreen
    );
  }
}
