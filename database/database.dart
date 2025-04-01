import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:aua_questions_app/Model/Question%20Model/question_model.dart';
import 'package:aua_questions_app/Model/Subject%20model/subject_model.dart';
import 'package:aua_questions_app/Model/grades%20model/grades_model.dart';
import 'package:aua_questions_app/Model/module_model/module_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxController {
  // Constants for API configuration
  static const String _endpoint = 'https://cloud.appwrite.io/v1';
  static const String _projectId = '65f463fd706dd4b9b48f';
  static const String _databaseId = '65343991a4a9ab79fba9';

  // Collection IDs
  static const String _gradesCollectionId = '6542a9272b788c3db095';
  static const String _modulesCollectionId = '65343999ed7099ac98a2';
  static const String _subjectsCollectionId = '653439a525d68c3f63a1';
  static const String _questionsCollectionId = '6535a638bcc1fdb13187';
  static const String _wrongAnswersCollectionId = '654780d9443608914100';
  static const String _apikey =
      'standard_04b80b41e484d6982a2261e5a34a1606ef4b4ccbbfc0525626d26979755f6ebfbc61153224c5c2e0d7b79f86f8fcf1db6bcc19d7a4512692f8c2ccb7bb7ae0816e6f3ad06cd3ec5c4182549c8d9ab157f1ab63d1c41c6d8909668a05442eeefb38d4087ed4615596132dc56a3f182240101fe6d7519b6d7dde26b17fdf824c26';

  // Appwrite SDK clients
  late final Client _client;
  late final Databases _databases;

  // Initialize SDK clients
  DatabaseService() {
    _client = Client()
      ..setEndpoint(_endpoint)
      ..setProject(_projectId);

    _databases = Databases(_client);
  }

  // Fetch grades
  Future<List<GradeModel>> getGrades() async {
    try {
      final DocumentList response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _gradesCollectionId,
      );

      if (response.documents.isNotEmpty) {
        print(response.documents);
        return response.documents
            .map((doc) => GradeModel.fromJson(doc.data))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch grades: $e');
      return [];
    }
  }

  // Fetch modules for a grade
  Future<List<ModuleModel>> getModules(String gradeId) async {
    try {
      print("try fetch module");

      final DocumentList response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _modulesCollectionId,
        queries: [
          Query.equal('grade_id', [gradeId]),
        ],
      );

      print("Response data: ${response.documents.length} modules found");

      if (response.documents.isNotEmpty) {
        return response.documents
            .map((doc) => ModuleModel.fromJson(doc.data))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch modules: $e');
      return [];
    }
  }

  // Fetch subjects for a module
  Future<List<SubjectModel>> getSubjects(String moduleId) async {
    try {
      final DocumentList response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _subjectsCollectionId,
        queries: [
          Query.equal('module_id', moduleId),
        ],
      );

      if (response.documents.isNotEmpty) {
        return response.documents
            .map((doc) => SubjectModel.fromJson(doc.data))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch subjects: $e');
      return [];
    }
  }

  // Fetch questions for a subject
  Future<List<QuestionModel>> getQuestions(String subjectId) async {
    try {
      int offset = 0;
      List<QuestionModel> allQuestions = [];
      bool hasMore = true;

      while (hasMore) {
        final DocumentList response = await _databases.listDocuments(
          databaseId: _databaseId,
          collectionId: _questionsCollectionId,
          queries: [
            Query.equal('subject_id', subjectId),
            Query.limit(25),
            Query.offset(offset),
          ],
        );

        if (response.documents.isNotEmpty) {
          final List<QuestionModel> questions = response.documents
              .map((doc) => QuestionModel.fromJson(doc.data))
              .toList();

          allQuestions.addAll(questions);

          if (questions.length < 25) {
            hasMore = false;
          } else {
            offset += questions.length;
          }
        } else {
          hasMore = false;
        }
      }

      return allQuestions;
    } catch (e) {
      debugPrint('Failed to fetch questions: $e');
      return [];
    }
  }

  // Report a wrong answer
  Future<bool> reportWrongAnswer({
    required String questionId,
    required String questionTitle,
    required String description,
  }) async {
    try {
      final String uniqueId =
          '${DateTime.now().millisecondsSinceEpoch}-${1000 + (DateTime.now().microsecond % 9000)}';

      final document = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _wrongAnswersCollectionId,
        documentId: uniqueId,
        data: {
          "question_id": questionId,
          "question_title": questionTitle,
          "description": description,
        },
      );

      return document.$id.isNotEmpty;
    } catch (e) {
      debugPrint('Failed to report wrong answer: $e');
      return false;
    }
  }
}
