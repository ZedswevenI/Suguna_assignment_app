import 'package:get/get.dart';

class AssignmentItem {
  final int phase;
  final String chapter;
  final String topicGroup;
  final bool isCompleted;

  AssignmentItem({
    required this.phase,
    required this.chapter,
    required this.topicGroup,
    this.isCompleted = false,
  });
}

class AssignmentControlController extends GetxController {
  var isLoading = false.obs;

  // Information
  var subject = 'Mathematics'.obs;
  var className = '9'.obs;
  var batchCode = 'COIFR248A01'.obs;

  // Assignment Items
  var assignmentItems = <AssignmentItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    try {
      isLoading.value = true;
      // TODO: Load assignments from API
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      // Sample data based on the design
      assignmentItems.value = [
        // Phase 1
        AssignmentItem(
          phase: 1,
          chapter: 'Euclid Geometry(9)',
          topicGroup: 'Euclid Geometry',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'Lines And Angles(9)',
          topicGroup: 'Lines And Angles',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'NISL(9)',
          topicGroup: 'Irrational Numbers And Indices',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'NISL(9)',
          topicGroup: 'Logarithm',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'NISL(9)',
          topicGroup: 'Review Of Numbers',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'NISL(9)',
          topicGroup: 'Surds',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'Polynomials(9)',
          topicGroup: 'Polynomials',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 1,
          chapter: 'Polynomials(9)',
          topicGroup: 'Theorems Related To Polynomials',
          isCompleted: true,
        ),
        // Phase 2
        AssignmentItem(
          phase: 2,
          chapter: 'Co-Ordinate Geometry-1(9)',
          topicGroup: 'Co-Ordinate Geometry',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'Heron\'s Formula(9)',
          topicGroup: 'Heron\'s Formula',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'LETV-1(9)',
          topicGroup: 'INTRODUCTION TO LINEAR EQUATIONS IN',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'LETV-1(9)',
          topicGroup: 'Introduction To Linear Equations In Two',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'LETV-1(9)',
          topicGroup: 'Solution Of Linear Equations In Two',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'Triangles(9)',
          topicGroup: 'Inequalities Of Triangles',
          isCompleted: true,
        ),
        AssignmentItem(
          phase: 2,
          chapter: 'Triangles(9)',
          topicGroup: 'Properties Of Triangles',
          isCompleted: true,
        ),
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load assignments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleCompletion(AssignmentItem item) {
    final index = assignmentItems.indexWhere(
      (element) =>
          element.phase == item.phase &&
          element.chapter == item.chapter &&
          element.topicGroup == item.topicGroup,
    );
    if (index != -1) {
      assignmentItems[index] = AssignmentItem(
        phase: item.phase,
        chapter: item.chapter,
        topicGroup: item.topicGroup,
        isCompleted: !item.isCompleted,
      );
    }
  }

  void refreshAssignments() {
    loadAssignments();
  }
}
