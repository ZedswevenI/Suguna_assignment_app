import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';

class HomeAssignmentsController extends GetxController {
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
  }

  void loadSubjects() {
    isLoading.value = true;
    subjects.value = MockDataService.getSubjects();
    isLoading.value = false;
  }

  void onSubjectTap(SubjectModel subject) {
    Get.toNamed(AppRoutes.topicAssignments, arguments: subject);
  }
}
