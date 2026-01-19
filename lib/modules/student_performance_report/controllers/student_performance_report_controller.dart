import 'package:get/get.dart';

class StudentPerformanceItem {
  final String enrolmentNumber;
  final String studentName;
  final double asgnScore;
  final double testScore;
  final double netScore;
  final String? cgpa;

  StudentPerformanceItem({
    required this.enrolmentNumber,
    required this.studentName,
    required this.asgnScore,
    required this.testScore,
    required this.netScore,
    this.cgpa,
  });

  // Determine if net score is high (orange) or low (pink/red)
  bool get isHighNetScore => netScore >= 2.0;
}

class StudentPerformanceReportController extends GetxController {
  var isLoading = false.obs;

  // Report header information
  var batchCode = 'COIFR248A01'.obs;
  var subject = 'Mathematics'.obs;

  // Student performance data
  var studentPerformanceItems = <StudentPerformanceItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStudentReports();
  }

  Future<void> loadStudentReports() async {
    try {
      isLoading.value = true;
      // TODO: Load student performance reports from API
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      // Sample data based on the image
      studentPerformanceItems.value = [
        StudentPerformanceItem(
          enrolmentNumber: '9020642480020',
          studentName: 'AAKAASH ANESHPRABU',
          asgnScore: 1.98,
          testScore: 9.71,
          netScore: 2.71,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480035',
          studentName: 'ABINAYAA V',
          asgnScore: 2.19,
          testScore: 6.82,
          netScore: 2.61,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480013',
          studentName: 'ADITYA',
          asgnScore: 0.97,
          testScore: 3.06,
          netScore: 1.14,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480008',
          studentName: 'AJITNARAYAN KUPPURAJAN',
          asgnScore: 1.94,
          testScore: 7.03,
          netScore: 2.43,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480007',
          studentName: 'AKSHITHA JAGADEESH',
          asgnScore: 1.75,
          testScore: 7.23,
          netScore: 2.25,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480024',
          studentName: 'ANANYA S V',
          asgnScore: 2.5,
          testScore: 6.36,
          netScore: 2.86,
        ),
        StudentPerformanceItem(
          enrolmentNumber: '9020642480016',
          studentName: 'ARJUN VENKATESH',
          asgnScore: 0.43,
          testScore: 8.74,
          netScore: 1.19,
        ),
      ];

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load student performance reports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void refreshReports() {
    loadStudentReports();
  }
}
