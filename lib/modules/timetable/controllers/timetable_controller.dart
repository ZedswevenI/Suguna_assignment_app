import 'package:get/get.dart';

class TimetableController extends GetxController {
  var isLoading = false.obs;
  var timetableData = <Map<String, dynamic>>[].obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    try {
      isLoading.value = true;
      // TODO: Load timetable data from API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      // timetableData.value = await apiService.getTimetable();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load timetable: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    loadTimetable();
  }

  void refreshTimetable() {
    loadTimetable();
  }
}

