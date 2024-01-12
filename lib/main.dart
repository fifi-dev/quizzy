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
          primary: Color(0xFF5585FF), // Titres en bleu
          onPrimary: Colors.white, // Textes en blanc
          background: Color(0xFF040404), // Fond sombre
          onBackground: Colors.white, // Textes en blanc
          surface: Colors.white, // Surface (peut être ajusté selon les besoins)
          onSurface: Colors.white, // Texte sur la surface
        ),
        hoverColor: Color(0xFF5585FF),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Texte du corps
          bodyText2: TextStyle(color: Colors.white), // Texte du corps
          headline6: TextStyle(color: Color(0xFF5585FF)), // Titres en bleu
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Fond blanc des boutons
            onPrimary: const Color(0xFF5585FF), // Texte en bleu des boutons
            onSurface: const Color(0xFF5585FF), // Couleur au survol des boutons
          ),
        ),
      ),
      home: FutureBuilder<List<Question>>(
        // Utilisez FutureBuilder pour obtenir les questions depuis la base de données
        future: DatabaseHelper().checkLastUpdateAndFetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez une indication de chargement si les données ne sont pas encore disponibles
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Affichez une erreur si la récupération des données échoue
            return Text('Erreur: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Si les données sont disponibles, passez-les à l'écran d'accueil
            return WelcomeScreen(questions: snapshot.data!);
          } else {
            // Sinon, affichez un message par défaut
            return Text('Aucune question trouvée');
          }
        },
      ),
    );
  }
}
