import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final bool isAnswerCorrect;
  final int score;

  ResultScreen({required this.isAnswerCorrect, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Votre score : $score',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers l'écran de bienvenue ou réinitialiser le quiz
              },
              child: Text('Recommencer le Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
