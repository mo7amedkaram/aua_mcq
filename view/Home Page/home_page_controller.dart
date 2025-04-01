import 'package:get/get.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

import '../../Model/grades model/grades_model.dart';

class HomePageController extends GetxController {
  var isLoading = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getGrades();
  }

  var grades = <GradesModel>[];
  //------------------------------
  Future<void> getGrades() async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      final userList = await databases.listDocuments(
        databaseId: '65343991a4a9ab79fba9',
        collectionId: '6542a9272b788c3db095',
      );

      for (var document in userList.documents) {
        grades.add(GradesModel.fromJson(document.data));
      }
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }
/*
  void moveDocuments() async {
    Client client = Client();
    Databases database = Databases(client);
    client
            .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
            .setProject('65f463fd706dd4b9b48f') // Your project ID
            .setKey(
                '488e9ab42ecaca22b4338af86a85686509e1e48a0c4ac02069408ef0fdb879711fc1a1c6deed33cfba0934628bef3a6868e709740ae83686db1615fb0c64b858eff51d470739daf50469101fddee53fbb4bba43f60f921be250c096877a23762befbd0705a4d8ad95762f920ebc8f5d149d6de4c5dc097f27663af01fcf67cf3') // Your secret API key
        ;

    // Source collection information
    final sourceCollectionId = '64970516a8950b261d23';
    final sourceDatabaseId = '649704fb5247716b4b1f';

    // Destination collection information
    final destinationCollectionId = '6535a638bcc1fdb13187';
    final destinationDatabaseId = '65343991a4a9ab79fba9';

    try {
      // Fetch documents from the source collection
      final sourceDocuments = await database.listDocuments(
          collectionId: sourceCollectionId,
          databaseId: sourceDatabaseId,
          queries: [Query.limit(352), Query.offset(0)]);

      for (final document in sourceDocuments.documents) {
        // Remove document from the source collection
        await database.deleteDocument(
          collectionId: sourceCollectionId,
          databaseId: sourceDatabaseId,
          documentId: document.$id,
          // Use the existing document ID
        );

        // Extract and check properties
        final questionTitle = document.data['questionTitle'] ?? '';
        final options = document.data['options'] ?? [];
        final answer = document.data['answer'] ?? '';

        // Insert document into the destination collection
        await database.createDocument(
          collectionId: destinationCollectionId,
          databaseId: destinationDatabaseId,
          documentId: ID.unique(),
          data: {
            "questionTitle": questionTitle,
            "options": options,
            "answer": answer,
            "subject_id": "6555fb196355866ba360",
          },
        );
      }

      print('Documents moved successfully.');
    } catch (e) {
      print('Error moving documents: $e');
    }
  }
  */
}
