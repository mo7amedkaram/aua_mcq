import 'package:get/get.dart';

import '../../Model/module_model/module_model.dart';
import '../../database/database.dart';

class ModulesController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  final RxBool isLoading = false.obs;
  final RxList<ModuleModel> modules = <ModuleModel>[].obs;

  final String gradeId;

  ModulesController({required this.gradeId});

  @override
  void onInit() {
    super.onInit();
    fetchModules();
  }

  Future<void> fetchModules() async {
    try {
      isLoading.value = true;
      final fetchedModules = await _databaseService.getModules(gradeId);
      modules.assignAll(fetchedModules);
    } catch (e) {
      print('Error fetching modules: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
