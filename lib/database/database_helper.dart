import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quizzy/models/question.dart';
import 'package:quizzy/models/answer.dart';

class DatabaseHelper {
  late Database _database;

  // Constructor to initialize the database
  DatabaseHelper() {
    initDatabase();
  }

  // Initialize the SQLite database
  Future<void> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'quiz_database.db');

    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            answers TEXT
          )
          '''
        );
      },
    );
    
    // Check if it's the first launch and download questions
    await checkFirstLaunch();
  }

  // Check if it's the first launch, if yes, download questions and store in the database
  Future<void> checkFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No Internet connection. Unable to download questions.');
        return;
      }

      final questions = await fetchQuestions();
      if (questions.isNotEmpty) {
        await insertQuestions(questions);
        prefs.setString('last_update', DateTime.now().toIso8601String());
      }

      prefs.setBool('first_launch', false);
    }
  }

  // Fetch questions from a remote server
  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(
      Uri.parse('https://flutter-learning-iim.web.app/json/questions.json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> questionsData = data['questions'];

      return questionsData.map((questionData) {
        return Question(
          text: questionData['intitule'],
          answers: (questionData['reponses'] as List<dynamic>).map((answerData) {
            return Answer(
              text: answerData['intitule'],
              isCorrect: answerData['id'] == questionData['bonneReponse'],
            );
          }).toList(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Insert questions into the SQLite database
  Future<void> insertQuestions(List<Question> questions) async {
    final db = await database;

    for (var question in questions) {
      await db.insert(
        'questions',
        {
          'text': question.text,
          'answers': jsonEncode(question.answers),
        },
      );
    }
  }
  
  // Getter for the database, ensuring it's open
  Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      await initDatabase();
      return _database;
    }
  }
}
