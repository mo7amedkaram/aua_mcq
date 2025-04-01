/*import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

import '../Model/Question Model/question_model.dart';

class AppwriteRepository extends GetxController {
  static AppwriteRepository get instance => Get.find<AppwriteRepository>();

  final Client client = Client();
  late final Account account;
  late final Databases databases;

  // Appwrite configuration
  final String endpoint = 'https://cloud.appwrite.io/v1';
  final String projectId = '65f463fd706dd4b9b48f';
  final String databaseId = '65343991a4a9ab79fba9';

  // Collection IDs
  final String usersCollectionId = '65ac5736d76070d8b547';
  final String gradesCollectionId = '6542a9272b788c3db095';
  final String modulesCollectionId = '65343999ed7099ac98a2';
  final String subjectsCollectionId = '653439a525d68c3f63a1';
  final String questionsCollectionId = '6535a638bcc1fdb13187';
  final String errorReportsCollectionId = '654780d9443608914100';
  final String appVersionCollectionId = '65c04ad2cc57aa25db07';

  @override
  void onInit() {
    super.onInit();

    client.setEndpoint(endpoint).setProject(projectId);

    account = Account(client);
    databases = Databases(client);
  }

  // Authentication methods
  Future<Session> createEmailSession(
      {required String email, required String password}) async {
    try {
      return await account.createEmailSession(email: email, password: password);
    } catch (e) {
      AppLogger.error('Failed to create email session', e);
      rethrow;
    }
  }

  Future<User> getAccountInfo() async {
    try {
      return await account.get();
    } catch (e) {
      AppLogger.error('Failed to get account info', e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSessions();
    } catch (e) {
      AppLogger.error('Failed to logout', e);
      rethrow;
    }
  }

  // User data methods
  Future<String?> checkUserId({required String userId}) async {
    try {
      final documents = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        queries: [Query.equal("user_id", userId)],
      );

      if (documents.documents.isNotEmpty) {
        return documents.documents[0].data["user_id"];
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to check user ID', e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData({required String userId}) async {
    try {
      final documents = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        queries: [Query.equal("user_id", userId)],
      );

      if (documents.documents.isNotEmpty) {
        return documents.documents[0].data;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get user data', e);
      return null;
    }
  }

  Future<void> createUserDocument({
    required String userId,
    required String userName,
    required String userEmail,
    required String phoneNumber,
    required String deviceId,
  }) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        documentId: ID.unique(),
        data: {
          "user_id": userId,
          "user_name": userName,
          "user_email": userEmail,
          "user_phone_number": phoneNumber,
          "user_device_id": deviceId
        },
      );
    } catch (e) {
      AppLogger.error('Failed to create user document', e);
      rethrow;
    }
  }

  // Grades methods
  Future<List<GradeModel>> getGrades() async {
    try {
      final List<GradeModel> grades = [];

      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: gradesCollectionId,
      );

      for (var document in response.documents) {
        grades.add(GradeModel.fromJson(document.data));
      }

      return grades;
    } catch (e) {
      AppLogger.error('Failed to fetch grades', e);
      return [];
    }
  }

  // Modules methods
  Future<List<ModuleModel>> getModules({required String gradeId}) async {
    try {
      final List<ModuleModel> modules = [];

      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: modulesCollectionId,
        queries: [Query.equal("grade_id", gradeId)],
      );

      for (var document in response.documents) {
        modules.add(ModuleModel.fromJson(document.data));
      }

      return modules;
    } catch (e) {
      AppLogger.error('Failed to fetch modules', e);
      return [];
    }
  }

  // Subjects methods
  Future<List<SubjectModel>> getSubjects({required String moduleId}) async {
    try {
      final List<SubjectModel> subjects = [];

      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: subjectsCollectionId,
        queries: [Query.equal("module_id", moduleId)],
      );

      for (var document in response.documents) {
        subjects.add(SubjectModel.fromJson(document.data));
      }

      return subjects;
    } catch (e) {
      AppLogger.error('Failed to fetch subjects', e);
      return [];
    }
  }

  // Questions methods
  Future<List<QuestionModel>> getQuestions({required String subjectId}) async {
    try {
      final List<QuestionModel> questions = [];
      int offset = 0;

      while (true) {
        final response = await databases.listDocuments(
          databaseId: databaseId,
          collectionId: questionsCollectionId,
          queries: [
            Query.equal("subject_id", subjectId),
            Query.limit(25),
            Query.offset(offset),
          ],
        );

        if (response.documents.isEmpty) {
          break;
        }

        for (var document in response.documents) {
          questions.add(QuestionModel.fromJson(document.data));
        }

        offset += response.documents.length;
      }

      return questions;
    } catch (e) {
      AppLogger.error('Failed to fetch questions', e);
      return [];
    }
  }

  // Report error
  Future<void> reportErrorInQuestion({
    required String questionId,
    required String questionTitle,
    required String description,
  }) async {
    try {
      await databases.createDocument(
        databaseId: databaseId,
        collectionId: errorReportsCollectionId,
        documentId: ID.unique(),
        data: {
          "question_id": questionId,
          "question_title": questionTitle,
          "description": description,
        },
      );
    } catch (e) {
      AppLogger.error('Failed to report error', e);
      rethrow;
    }
  }

  // App version
  Future<String?> getAppVersion() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: appVersionCollectionId,
      );

      if (response.documents.isNotEmpty) {
        return response.documents[0].data["data"];
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to get app version', e);
      return null;
    }
  }
}
 */
