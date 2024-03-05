import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/screens/result_screen.dart';
import 'package:quizzy/models/question.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF040404),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF5585FF), // Blue title
          onPrimary: Colors.white, // white text
          background: Color(0xFF040404), // dark background
          onBackground: Colors.white, // white text
          surface: Colors.white, // Surface
          onSurface: Color(0xFF5585FF), // Text on surface
        ),
        hoverColor: Color(0xFF5585FF).withOpacity(0.1),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // body text
          bodyText2: TextStyle(color: Colors.white), // body text
          headline6: TextStyle(color: Color(0xFF5585FF)), // blue title
        ),
      ),
      home: QuestionScreen(questions: questions),
    );
  }
}

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
    print('Moving to the next question...');
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
        backgroundColor: Colors.black,
        title: Text(
          'Question ${currentIndex + 1}',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Image.asset(
              'assets/images/quizzy_logo.png',
              height: 80, 
              width: 80, 
            ),
            SizedBox(height: 32),
            Text(
              widget.questions[currentIndex].text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: widget.questions[currentIndex].answers.map((answer) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAnswer = answer;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: selectedAnswer == answer ? Color(0xFF5585FF) : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      answer.text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedAnswer != null) {
                  // Evaluate the answer and update the score
                  bool isCorrect = selectedAnswer!.isCorrect;
                  setState(() {
                    if (isCorrect) {
                      score += 10;
                    }
                  });

                  // display feedback
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
