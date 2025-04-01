import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/database_model.dart';

class DatabaseManager {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'questions.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE questions(id INTEGER PRIMARY KEY AUTOINCREMENT, questionTitle TEXT, options TEXT, answer INTEGER)",
        );
      },
      version: 1,
    );
  }

  // إضافة طرق للإدراج، القراءة، الحذف، والتحديث

  Future<void> insertQuestion(Question question) async {
    final db = await database;
    await db.insert(
      'questions',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Question>> getQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');

    return List.generate(maps.length, (i) {
      return Question.fromMap(maps[i]);
    });
  }

  // delete question
  Future<void> deleteQuestion(int id) async {
    final db = await database;
    await db.delete(
      'questions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
