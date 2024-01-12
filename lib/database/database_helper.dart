import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quizzy/models/question.dart';
import 'package:quizzy/models/answer.dart';

class DatabaseHelper {
  Database? _database; // Change late Database to Database?

  DatabaseHelper() {
    initDatabase();
  }

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

  Future<void> checkFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No Internet connection. Unable to download questions.');
        await useLocalQuestionsOrShowError();
        return;
      }

      final questions = await fetchQuestions();
      if (questions.isNotEmpty) {
        await insertQuestions(questions);
        prefs.setString('last_update', DateTime.now().toIso8601String());
      } else {
        await useLocalQuestionsOrShowError();
      }

      prefs.setBool('first_launch', false);
    }
  }

  Future<void> useLocalQuestionsOrShowError() async {
    final questions = await getLocalQuestions();
    if (questions.isNotEmpty) {
      print('Using local questions.');
    } else {
      print('No local questions available. Display an error message.');
    }
  }

  Future<List<Question>> getLocalQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> questionsData = await db.query('questions');
    return questionsData.map((questionData) {
      return Question(
        text: questionData['text'],
        answers: (jsonDecode(questionData['answers']) as List<dynamic>).map((answerData) {
          return Answer(
            text: answerData['text'],
            isCorrect: answerData['isCorrect'],
          );
        }).toList(),
      );
    }).toList();
  }

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(
      Uri.parse('https://flutter-learning-iim.web.app/json/questions.json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> questionsData =
          List<Map<String, dynamic>>.from(data['questions']);

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

  Future<void> insertQuestions(List<Question> questions) async {
    final db = await database;

    for (var question in questions) {
      await db.insert(
        'questions',
        {
          'text': question.text,
          'answers': jsonEncode(question.answers.map((answer) => answer.toJson()).toList()),
        },
      );
    }
  }

  Future<List<Question>> checkLastUpdateAndFetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastUpdateString = prefs.getString('last_update');
    DateTime? lastUpdate = lastUpdateString != null
        ? DateTime.tryParse(lastUpdateString)
        : null;

    if (lastUpdate == null || DateTime.now().difference(lastUpdate).inMinutes > 5) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return await getQuestions(); // No internet, return local questions
      }

      final questions = await fetchQuestions();
      if (questions.isNotEmpty) {
        await insertQuestions(questions);
        prefs.setString('last_update', DateTime.now().toIso8601String());
      }

      return questions;
    } else {
      return await getQuestions(); // Return local questions
    }
  }

  Future<List<Question>> getQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question(
        text: maps[i]['text'],
        answers: List<Answer>.from(
          jsonDecode(maps[i]['answers']).map((answer) {
            return Answer(
              text: answer['text'],
              isCorrect: answer['isCorrect'],
            );
          }),
        ),
      );
    });
  }

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    } else {
      await initDatabase();
      return _database!;
    }
  }
}
