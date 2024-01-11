import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/models/question.dart';
import 'result_screen.dart';

class QuestionScreen extends StatefulWidget {
  final Question question;

  QuestionScreen({required this.question});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // Déclarez la variable selectedAnswer
  Answer? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.question.text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            // Afficher les options de réponse ici
            Column(
              children: widget.question.answers.map((answer) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        isAnswerCorrect: selectedAnswer!.isCorrect,
                        score: 100, // Remplacez ceci par le score réel de votre application
                      ),
                    ),
                  );
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
