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
      // Ajoutez d'autres questions ici...
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF040404),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF5585FF), // Titres en bleu
          onPrimary: Colors.white, // Textes en blanc
          background: Color(0xFF040404), // Fond sombre
          onBackground: Colors.white, // Textes en blanc
          surface: Colors.white, // Surface (peut être ajusté selon les besoins)
          onSurface: Color(0xFF5585FF), // Texte sur la surface
        ),
        hoverColor: Color(0xFF5585FF).withOpacity(0.1),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Texte du corps
          bodyText2: TextStyle(color: Colors.white), // Texte du corps
          headline6: TextStyle(color: Color(0xFF5585FF)), // Titres en bleu
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
                      // Autres styles de décoration au besoin
                    ),
                    child: Text(
                      answer.text,
                      style: TextStyle(
                        color: Colors.white,
                        // Autres styles de texte au besoin
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
