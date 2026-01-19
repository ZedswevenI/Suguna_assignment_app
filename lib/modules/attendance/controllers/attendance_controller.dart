import 'package:get/get.dart';

class StudentAttendanceItem {
  final String enrolmentNumber;
  final String studentName;
  bool isPresent;

  StudentAttendanceItem({
    required this.enrolmentNumber,
    required this.studentName,
    this.isPresent = false,
  });
}

class AttendanceController extends GetxController {
  var isLoading = false.obs;

  // Information
  var subject = 'Mathematics'.obs;
  var className = '9'.obs;
  var batchCode = 'COIFR248A01'.obs;
  var date = DateTime.now().obs;

  // Student attendance data
  var studentAttendanceItems = <StudentAttendanceItem>[].obs;

  // Search query
  var searchQuery = ''.obs;

  // Check all state
  var isAllChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    try {
      isLoading.value = true;
      // TODO: Load attendance data from API
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      // Sample student data
      studentAttendanceItems.value = [
        StudentAttendanceItem(
          enrolmentNumber: '9020642480020',
          studentName: 'AAKAASH ANESHPRABU',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480035',
          studentName: 'ABINAYAA V',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480013',
          studentName: 'ADITYA',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480008',
          studentName: 'AJITNARAYAN KUPPURAJAN',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480007',
          studentName: 'AKSHITHA JAGADEESH',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480024',
          studentName: 'ANANYA S V',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480016',
          studentName: 'ARJUN VENKATESH',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480018',
          studentName: 'AVANEESH V',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480019',
          studentName: 'BALAJI K',
          isPresent: false,
        ),
        StudentAttendanceItem(
          enrolmentNumber: '9020642480021',
          studentName: 'CHANDRA SEKHAR',
          isPresent: false,
        ),
      ];

      updateCheckAllState();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load attendance: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleStudentAttendance(int index) {
    if (index >= 0 && index < studentAttendanceItems.length) {
      studentAttendanceItems[index].isPresent =
          !studentAttendanceItems[index].isPresent;
      updateCheckAllState();
    }
  }

  void toggleAllAttendance() {
    final newValue = !isAllChecked.value;
    isAllChecked.value = newValue;

    // Only toggle filtered items if search is active
    final itemsToToggle = searchQuery.value.isEmpty
        ? studentAttendanceItems
        : filteredStudentItems;

    for (var item in itemsToToggle) {
      item.isPresent = newValue;
    }
  }

  void updateCheckAllState() {
    final filteredList = filteredStudentItems;
    if (filteredList.isEmpty) {
      isAllChecked.value = false;
      return;
    }

    isAllChecked.value = filteredList.every((item) => item.isPresent);
  }

  List<StudentAttendanceItem> get filteredStudentItems {
    if (searchQuery.value.isEmpty) {
      return studentAttendanceItems;
    }

    final query = searchQuery.value.toLowerCase();
    return studentAttendanceItems.where((item) {
      return item.studentName.toLowerCase().contains(query) ||
          item.enrolmentNumber.toLowerCase().contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  int get presentCount {
    return studentAttendanceItems.where((item) => item.isPresent).length;
  }

  int get totalCount {
    return studentAttendanceItems.length;
  }

  Future<void> submitAttendance() async {
    try {
      isLoading.value = true;
      // TODO: Submit attendance to API
      await Future.delayed(const Duration(milliseconds: 500));
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Attendance submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to submit attendance: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void refreshAttendance() {
    loadAttendance();
  }
}
