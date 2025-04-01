// File: lib/core/services/local_database_service.dart

import 'package:aua_questions_app/database/local_databse_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

import '../Model/local question model/local_question_model.dart';

class LocalDatabaseService extends GetxController {
  static const String _tableName = 'questions';
  Database? _database;

  // Singleton pattern
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  // Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Create and open database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aua_questions.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            questionTitle TEXT,
            options TEXT,
            answer INTEGER
          )
          ''');
      },
    );
  }

  // Add question to favorites
  Future<int> addQuestion(LocalQuestion question) async {
    final db = await database;
    return await db.insert(
      _tableName,
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all favorite questions
  Future<List<LocalQuestion>> getAllQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return LocalQuestion.fromMap(maps[i]);
    });
  }

  // Delete question from favorites
  Future<int> deleteQuestion(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Check if a question exists
  Future<bool> questionExists(String questionTitle) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'questionTitle = ?',
      whereArgs: [questionTitle],
    );

    return result.isNotEmpty;
  }

  // Clear all favorite questions
  Future<int> clearAllQuestions() async {
    final db = await database;
    return await db.delete(_tableName);
  }
}
