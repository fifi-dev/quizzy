import 'package:flutter/material.dart';

import '../models/question.dart';

class QuestionScreen extends StatelessWidget {
  final Question question;

  QuestionScreen({required this.question});

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
              question.text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            // Afficher les options de réponse ici
          ],
        ),
      ),
    );
  }
}
