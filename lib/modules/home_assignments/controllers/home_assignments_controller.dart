import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/resources/app_strings.dart';
import 'package:suguna_assignment_app/core/services/api_service.dart';
import 'package:suguna_assignment_app/core/services/assigment_api_services.dart';
import 'package:suguna_assignment_app/core/services/service_locator.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/services/network_service.dart';
import 'package:suguna_assignment_app/data/services/sessions.dart';

import '../../../data/services/store_service.dart';

class HomeAssignmentsController extends GetxController {
  // ===============================
  // API
  // ===============================
  final AssignmentApiServices _apiService =
  ServiceLocator.get<AssignmentApiServices>();

  // ===============================
  // STATE
  // ===============================C
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


  final storage = Get.find<StorageService>();
  final ayHistory = <Map<String, dynamic>>[].obs;
  // ===============================
  // LIFECYCLE
  // ===============================
  @override
  void onInit() {
    super.onInit();

    // Read arguments from login navigation
    loginResponse = storage.getUser() ?? {};
    studentData = loginResponse['data'];

    _initStudentContext();
    loadSubjects();
  }

  // ===============================
  // INITIAL SETUP
  // ===============================
  void _initStudentContext() {
    selectedAcademicYear.value = studentData['currentAcademicYear'] ?? '';

    final List history = studentData['ayHistory'] ?? [];

    ayHistory.assignAll(List<Map<String, dynamic>>.from(history));

    academicYears.assignAll(
      ayHistory.map((e) => e['academicYear'].toString()).toList(),
    );

    final current = ayHistory.firstWhereOrNull(
          (e) => e['academicYear'] == selectedAcademicYear.value,
    );

    if (current != null) {
      currentClass.value = 'Class ${current['classNo']}';
      Session.instance.currentClass = current['classNo'];
    }
  }


  Future<void> loadSubjects() async {
    isLoading.value = true;

    try {
      final hasInternet = await NetworkService.hasInternet();
      final String classNo = studentData['tenantId']?.toString() ?? '';
      final String academicYear =
          studentData['admissionNo']?.toString() ?? '';

      if (hasInternet) {
        // ================= ONLINE =================
        final response =
        await _apiService.getAssignments(classNo, academicYear);

        if (response['status'] == true) {
          final subjectsJson =
          response['data']['subjects'] as List;

          // Save full API response locally
          storage.saveSubjects(response);

          subjects.assignAll(
            subjectsJson
                .map((e) => SubjectModel.fromJson(e))
                .toList(),
          );

          if (subjects.isNotEmpty) {
            selectedSubject.value = subjects.first;
          }
        }
      } else {
        // ================= OFFLINE =================
        final localData = storage.getSubjects();

        if (localData != null) {
          final subjectsJson =
          localData['data']['subjects'] as List;

          subjects.assignAll(
            subjectsJson
                .map((e) => SubjectModel.fromJson(e))
                .toList(),
          );

          if (subjects.isNotEmpty) {
            selectedSubject.value = subjects.first;
          }
        } else {
          Get.snackbar(
            "No Internet",
            "No cached data available",
          );
        }
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

    final selected = ayHistory.firstWhereOrNull(
          (e) => e['academicYear'] == year,
    );

    if (selected != null) {
      currentClass.value = 'Class ${selected['classNo']}';
      Session.instance.currentClass = selected['classNo'];
    }

    selectedSubject.value = null;
    subjects.clear();

    loadSubjects();
  }

  // ===============================
  // SUBJECT CLICK
  // ===============================
  void onSubjectTap(SubjectModel subject) {
    Session.instance.selectedSubject = subject;
    Get.toNamed(
      AppRoutes.topicAssignments,
      arguments: subject,
    );
  }

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

}