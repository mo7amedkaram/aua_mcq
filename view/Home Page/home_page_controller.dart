import 'package:aua_questions_app/database/database.dart';
import 'package:get/get.dart';

import '../../Model/grades model/grades_model.dart';

class HomeController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  final RxBool isLoading = false.obs;
  final RxList<GradeModel> grades = <GradeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    try {
      isLoading.value = true;
      final fetchedGrades = await _databaseService.getGrades();
      print("fetches grade is $fetchedGrades");
      grades.assignAll(fetchedGrades);
    } catch (e) {
      print('Error fetching grades: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshGrades() {
    fetchGrades();
  }
}
