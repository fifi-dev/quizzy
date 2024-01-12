import 'package:flutter/material.dart';
import 'package:quizzy/screens/question_screen.dart';
import 'package:quizzy/models/question.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Question> questions;

  WelcomeScreen({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Quizzy',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Image.asset(
            'assets/images/quizzy_logo.png',
            height: 80, 
            width: 80, 
          ),
          SizedBox(height: 32),
            Text(
              'Welcome to the Quizzy app!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Test your knowledge with exciting questions.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      questions: questions,
                    ),
                  ),
                );
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
