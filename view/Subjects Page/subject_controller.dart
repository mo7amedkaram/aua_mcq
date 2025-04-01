import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';
import '../../database/database.dart';

class SubjectsController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  final RxBool isLoading = false.obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;

  final String moduleId;

  SubjectsController({required this.moduleId});

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    try {
      isLoading.value = true;
      final fetchedSubjects = await _databaseService.getSubjects(moduleId);
      subjects.assignAll(fetchedSubjects);
    } catch (e) {
      print('Error fetching subjects: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
