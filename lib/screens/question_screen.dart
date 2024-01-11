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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedAnswer != null) {
                  // Évaluez la réponse et mettez à jour le score
                  bool isCorrect = selectedAnswer!.isCorrect;
                  setState(() {
                    if (isCorrect) {
                      score += 10;
                    }
                  });

                  // Affichez le feedback immédiat
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(isCorrect ? 'Correct!' : 'Incorrect!'),
                        content: Text(isCorrect
                            ? 'Bonne réponse! Vous avez gagné 10 points.'
                            : 'Mauvaise réponse. Aucun point n\'a été gagné.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              goToNextQuestion();
                            },
                            child: Text('Continuer'),
                          ),
                        ],
                      );
                    },
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
