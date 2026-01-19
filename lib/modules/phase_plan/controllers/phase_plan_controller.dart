import 'package:get/get.dart';

class PhasePlanItem {
  final int phase;
  final int seq;
  final String chapter;
  final String courseCode;
  final int hours;
  final bool isCompleted;

  PhasePlanItem({
    required this.phase,
    required this.seq,
    required this.chapter,
    required this.courseCode,
    required this.hours,
    this.isCompleted = false,
  });
}

class PhasePlanController extends GetxController {
  var isLoading = false.obs;

  // Faculty and Batch Information
  var facultyName = 'Velliyangiri Nataraj'.obs;
  var batchCode = 'COIFR248A01'.obs;
  var subject = 'Mathematics'.obs;
  var className = '9'.obs;
  var programCode = '9020'.obs;

  // Phase Plan Items
  var phasePlanItems = <PhasePlanItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPhasePlan();
  }

  Future<void> loadPhasePlan() async {
    try {
      isLoading.value = true;
      // TODO: Load phase plan data from API
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      // Sample data
      phasePlanItems.value = [
        // Phase 1
        PhasePlanItem(
          phase: 1,
          seq: 1,
          chapter: 'NIS',
          courseCode: 'M0901',
          hours: 6,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 1,
          seq: 2,
          chapter: 'Polynomials',
          courseCode: 'M0902',
          hours: 10,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 1,
          seq: 3,
          chapter: 'Euclid Geometry',
          courseCode: 'M0903',
          hours: 5,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 1,
          seq: 4,
          chapter: 'Lines and Angles',
          courseCode: 'M0904',
          hours: 8,
          isCompleted: true,
        ),
        // Phase 2
        PhasePlanItem(
          phase: 2,
          seq: 1,
          chapter: 'Triangles',
          courseCode: 'M0906',
          hours: 6,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 2,
          seq: 2,
          chapter: 'Co-ordinate Geometry-1',
          courseCode: 'M0914',
          hours: 4,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 2,
          seq: 3,
          chapter: 'Herons Formula',
          courseCode: 'M0911',
          hours: 4,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 2,
          seq: 4,
          chapter: 'LETV-1',
          courseCode: 'M0905',
          hours: 5,
          isCompleted: true,
        ),
        // Phase 3
        PhasePlanItem(
          phase: 3,
          seq: 1,
          chapter: 'Quadrilateral',
          courseCode: 'M0907',
          hours: 8,
          isCompleted: true,
        ),
        PhasePlanItem(
          phase: 3,
          seq: 2,
          chapter: 'Areas of Parallelograms',
          courseCode: 'M0908',
          hours: 6,
          isCompleted: false,
        ),
        PhasePlanItem(
          phase: 3,
          seq: 3,
          chapter: 'Circles',
          courseCode: 'M0909',
          hours: 10,
          isCompleted: false,
        ),
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load phase plan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleCompletion(PhasePlanItem item) {
    final index = phasePlanItems.indexWhere(
      (i) =>
          i.phase == item.phase &&
          i.seq == item.seq &&
          i.chapter == item.chapter,
    );
    if (index != -1) {
      phasePlanItems[index] = PhasePlanItem(
        phase: item.phase,
        seq: item.seq,
        chapter: item.chapter,
        courseCode: item.courseCode,
        hours: item.hours,
        isCompleted: !item.isCompleted,
      );
      phasePlanItems.refresh();
      // TODO: Update completion status via API
    }
  }

  void refreshPhasePlan() {
    loadPhasePlan();
  }
}
