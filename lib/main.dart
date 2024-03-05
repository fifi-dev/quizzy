import 'package:flutter/material.dart';
import 'package:quizzy/models/answer.dart';
import 'package:quizzy/screens/welcome_screen.dart';
import 'package:quizzy/models/question.dart';
import 'package:quizzy/database/database_helper.dart';

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
          primary: Color(0xFF5585FF), // blue titles
          onPrimary: Colors.white, // white texte
          background: Color(0xFF040404), // dark background
          onBackground: Colors.white, // white text
          surface: Colors.white, // Surface
          onSurface: Colors.white, // surface text
        ),
        hoverColor: Color(0xFF5585FF),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), 
          bodyText2: TextStyle(color: Colors.white), 
          headline6: TextStyle(color: Color(0xFF5585FF)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // buttons white background 
            onPrimary: const Color(0xFF5585FF),
            onSurface: const Color(0xFF5585FF), // on hover 
          ),
        ),
      ),
      home: FutureBuilder<List<Question>>(
        // Use FutureBuilder to get questions from the database
        future: DatabaseHelper().checkLastUpdateAndFetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indication if data is not yet available
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Show an error if data fetching fails
            return Text('Erreur: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // If the data is available, pass it to the home screen
            return WelcomeScreen(questions: snapshot.data!);
          } else {
            // Otherwise, show a default message
            return Text('Aucune question trouvée');
          }
        },
      ),
    );
  }
}
