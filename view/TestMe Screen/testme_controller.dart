import 'package:get/get.dart';

import '../../Model/Subject model/subject_model.dart';
import '../../Model/grades model/grades_model.dart';
import '../../Model/module_model/module_model.dart';

class TestMeController extends GetxController {
  var isLoading = false.obs;
  var selectedGrade = Rxn<GradesModel>();
  var selectedModule = Rxn<ModuleModel>();
  var selectedSubject = Rxn<SubjectModel>();
}
