import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;

  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Résultat',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/quizzy_logo.png',
              height: 80, 
              width: 80, 
            ),
            SizedBox(height: 32),
            Text(
              'Votre score : $score',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Restart the quiz or take any other action
                Navigator.pop(context); // Return to the previous screen
              },
              child: Text('Recommencer le Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
