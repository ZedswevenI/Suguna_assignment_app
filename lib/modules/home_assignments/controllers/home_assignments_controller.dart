import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/resources/app_strings.dart';
import 'package:suguna_assignment_app/core/services/api_service.dart';
import 'package:suguna_assignment_app/core/services/assigment_api_services.dart';
import 'package:suguna_assignment_app/core/services/service_locator.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';

class HomeAssignmentsController extends GetxController {
  // ===============================
  // API
  // ===============================
  final AssignmentApiServices _apiService =
  ServiceLocator.get<AssignmentApiServices>();

  // ===============================
  // STATE
  // ===============================
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;

  final selectedSubject = Rx<SubjectModel?>(null);

  final academicYears = <String>[].obs;
  final selectedAcademicYear = ''.obs;

  final currentClass = ''.obs;

  // ===============================
  // LOGIN DATA
  // ===============================
  late final Map<String, dynamic> loginResponse;
  late final Map<String, dynamic> studentData;

  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();

    // Read arguments from login navigation
    loginResponse = Get.arguments as Map<String, dynamic>;
    studentData = loginResponse['data'];

    _initStudentContext();
    loadSubjects();
  }

  // ===============================
  // INITIAL SETUP
  // ===============================
  void _initStudentContext() {
    // Academic year
    selectedAcademicYear.value =
        studentData['currentAcademicYear'] ?? '';

    // Class
    final int classNo = studentData['classNo'];
    currentClass.value = 'Class $classNo';

    // Academic year history (dropdown)
    final List ayHistory = studentData['ayHistory'] ?? [];

    academicYears.assignAll(
      ayHistory
          .map((e) => e['academicYear'].toString())
          .toSet()
          .toList(),
    );
  }

  // ===============================
  // LOAD SUBJECTS
  // ===============================
  Future<void> loadSubjects() async {
    isLoading.value = true;

    try {
      final String classNo = studentData['tenantId'];
      final String academicYear = studentData['admissionNo'];
      final response = await _apiService.getAssignments(classNo,academicYear);
      subjects.assignAll(response);

      if (subjects.isNotEmpty) {
        selectedSubject.value = subjects.first;
      }
    } on ApiException catch (e) {
      Get.snackbar(AppStrings.error, e.message);
    } catch (e) {
      Get.snackbar(AppStrings.error, 'Failed to load subjects');
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // ACADEMIC YEAR CHANGE
  // ===============================
  void onAcademicYearChanged(String? year) {
    if (year == null || year == selectedAcademicYear.value) return;

    selectedAcademicYear.value = year;
    selectedSubject.value = null;
    subjects.clear();

    loadSubjects();
  }

  // ===============================
  // SUBJECT CLICK
  // ===============================
  void onSubjectTap(SubjectModel subject) {
    Get.toNamed(
      AppRoutes.topicAssignments,
      arguments: subject,
    );
  }
}