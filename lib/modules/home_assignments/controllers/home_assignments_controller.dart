import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';

class HomeAssignmentsController extends GetxController {
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;

  final Rx<SubjectModel?> selectedSubject = Rx<SubjectModel?>(null);

  final academicYears = <String>[
    '2023–24',
    '2024–25',
    '2025–26',
  ];

  final selectedAcademicYear = '2024–25'.obs;

  // Current class (studying)
  final currentClass = 'VII A'.obs;

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

  void onAcademicYearChanged(String? year) {
    if (year == null) return;

    selectedAcademicYear.value = year;

    // Reset state when year changes
    selectedSubject.value = null;
    subjects.clear();

    _reloadSubjectsForYear(year);
  }

  Future<void> _reloadSubjectsForYear(String year) async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    // Replace with API response
    subjects.assignAll(MockDataService.getSubjects());

    if (subjects.isNotEmpty) {
      selectedSubject.value = subjects.first;
    }

    isLoading.value = false;
  }


  void onSubjectTap(SubjectModel subject) {
    Get.toNamed(AppRoutes.topicAssignments, arguments: subject);
  }
}
