// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';

class SubjectController extends GetxController {
  SubjectController({
    this.moduleId,
  });
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSubjects();
  }

  final moduleId;
  var isLoading = false.obs;

  //-------------

  var subject = <SubjectModel>[];
  var subjectTest = <SubjectModel>[];

  Future<void> getSubjects() async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      final userList = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '653439a525d68c3f63a1',
          queries: [Query.equal("module_id", moduleId)]);

      for (var document in userList.documents) {
        subject.add(SubjectModel.fromJson(document.data));
      }
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTestSubjects({required String moduleTestId}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      final userList = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '653439a525d68c3f63a1',
          queries: [Query.equal("module_id", moduleTestId)]);

      for (var document in userList.documents) {
        subjectTest.add(SubjectModel.fromJson(document.data));
      }
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
