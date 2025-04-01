import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import '../../Model/module_model/module_model.dart';

class ModuleController extends GetxController {
  ModuleController({
    this.gradeId,
  });
  var isLoading = false.obs;
  final gradeId;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getModules();
  }

  var modules = <ModuleModel>[];
  var testModules = <ModuleModel>[];
  //------------------------------
  Future<void> getModules() async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      final userList = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '65343999ed7099ac98a2',
          queries: [Query.equal("grade_id", gradeId)]);

      for (var document in userList.documents) {
        modules.add(ModuleModel.fromJson(document.data));
      }
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }

//---------
  Future<void> getTestModules({required String gradeTestId}) async {
    Client client = Client();
    Databases databases = Databases(client);

    client
        .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('65f463fd706dd4b9b48f');

    try {
      isLoading.value = true;
      final userList = await databases.listDocuments(
          databaseId: '65343991a4a9ab79fba9',
          collectionId: '65343999ed7099ac98a2',
          queries: [Query.equal("grade_id", gradeTestId)]);

      for (var document in userList.documents) {
        testModules.add(ModuleModel.fromJson(document.data));
      }
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
