import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/routes/app_routes.dart';
import 'package:suguna_teachers_app/core/routes/route_config.dart';

class BatchControlController extends GetxController {
  var isLoading = false.obs;

  // Action options
  final actionOptions = [
    'Student Performance Report',
    'Batch Performance Report',
    'Assignment Control',
    'Phase Plan',
    'My Library',
  ].obs;

  var selectedAction = Rxn<String>();

  // Batch code options (sample data - replace with API data)
  final batchCodeOptions = [
    'COIFR248A01',
    'COIFR259A02',
    'COIFR270A03',
    'COIFR281A04',
  ].obs;

  var selectedBatchCode = Rxn<String>();

  // Subject options
  final subjectOptions = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
  ].obs;

  var selectedSubject = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      // TODO: Load data from API
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectAction(String? action) {
    selectedAction.value = action;
  }

  void selectBatchCode(String? batchCode) {
    selectedBatchCode.value = batchCode;
  }

  void selectSubject(String? subject) {
    selectedSubject.value = subject;
  }

  String? validateForm() {
    if (selectedAction.value == null) {
      return 'Please select an action';
    }

    if (selectedBatchCode.value == null) {
      return 'Please select a batch code';
    }

    if (selectedSubject.value == null) {
      return 'Please select a subject';
    }

    return null; // Validation passed
  }

  void submit() {
    final validationError = validateForm();
    if (validationError != null) {
      // Validation error will be handled in the widget
      return;
    }

    // Navigate based on selected action
    final action = selectedAction.value!;

    switch (action) {
      case 'Student Performance Report':
        RouteConfig.router.go(AppRoutes.studentPerformanceReport);
        break;
      case 'Batch Performance Report':
        RouteConfig.router.go(AppRoutes.batchPerformanceReport);
        break;
      case 'Assignment Control':
        RouteConfig.router.go(AppRoutes.assignmentControl);
        break;
      case 'Phase Plan':
        RouteConfig.router.go(AppRoutes.phasePlan);
        break;
      case 'My Library':
        RouteConfig.router.go(AppRoutes.myLibrary);
        break;
    }
  }

  void resetForm() {
    selectedAction.value = null;
    selectedBatchCode.value = null;
    selectedSubject.value = null;
  }
}
