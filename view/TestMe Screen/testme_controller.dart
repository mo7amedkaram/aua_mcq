import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';
import '../../Model/grades model/grades_model.dart';
import '../../Model/module_model/module_model.dart';
import '../../database/database.dart';

class TestController extends GetxController {
  final DatabaseService _databaseService = Get.find<DatabaseService>();

  // Loading states
  final RxBool isLoadingGrades = false.obs;
  final RxBool isLoadingModules = false.obs;
  final RxBool isLoadingSubjects = false.obs;

  // Data lists
  final RxList<GradeModel> grades = <GradeModel>[].obs;
  final RxList<ModuleModel> modules = <ModuleModel>[].obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;

  // Selected items
  final Rx<GradeModel?> selectedGrade = Rx<GradeModel?>(null);
  final Rx<ModuleModel?> selectedModule = Rx<ModuleModel?>(null);
  final Rx<SubjectModel?> selectedSubject = Rx<SubjectModel?>(null);

  // Test parameters
  final RxInt questionCount = 10.obs;
  final RxInt timeInMinutes = 15.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    try {
      isLoadingGrades.value = true;
      final fetchedGrades = await _databaseService.getGrades();
      grades.assignAll(fetchedGrades);
    } catch (e) {
      print('Error fetching grades for test: $e');
    } finally {
      isLoadingGrades.value = false;
    }
  }

  Future<void> fetchModules() async {
    if (selectedGrade.value == null) return;

    try {
      isLoadingModules.value = true;
      modules.clear();
      selectedModule.value = null;
      subjects.clear();
      selectedSubject.value = null;

      final fetchedModules =
          await _databaseService.getModules(selectedGrade.value!.id!);
      modules.assignAll(fetchedModules);
    } catch (e) {
      print('Error fetching modules for test: $e');
    } finally {
      isLoadingModules.value = false;
    }
  }

  Future<void> fetchSubjects() async {
    if (selectedModule.value == null) return;

    try {
      isLoadingSubjects.value = true;
      subjects.clear();
      selectedSubject.value = null;

      final fetchedSubjects =
          await _databaseService.getSubjects(selectedModule.value!.id!);
      subjects.assignAll(fetchedSubjects);
    } catch (e) {
      print('Error fetching subjects for test: $e');
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  void setSelectedGrade(GradeModel grade) {
    selectedGrade.value = grade;
    fetchModules();
  }

  void setSelectedModule(ModuleModel module) {
    selectedModule.value = module;
    fetchSubjects();
  }

  void setSelectedSubject(SubjectModel subject) {
    selectedSubject.value = subject;
  }

  void increaseQuestionCount() {
    if (questionCount.value < 50) {
      // Set a reasonable upper limit
      questionCount.value++;
    }
  }

  void decreaseQuestionCount() {
    if (questionCount.value > 5) {
      // Set a reasonable lower limit
      questionCount.value--;
    }
  }

  void increaseTime() {
    if (timeInMinutes.value < 60) {
      // Set a reasonable upper limit
      timeInMinutes.value++;
    }
  }

  void decreaseTime() {
    if (timeInMinutes.value > 5) {
      // Set a reasonable lower limit
      timeInMinutes.value--;
    }
  }

  bool isFormValid() {
    return selectedGrade.value != null &&
        selectedModule.value != null &&
        selectedSubject.value != null &&
        questionCount.value > 0 &&
        timeInMinutes.value > 0;
  }

  void reset() {
    selectedGrade.value = null;
    selectedModule.value = null;
    selectedSubject.value = null;
    modules.clear();
    subjects.clear();
    questionCount.value = 10;
    timeInMinutes.value = 15;
  }
}
