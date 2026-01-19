import 'package:get/get.dart';

class BatchPerformanceReportController extends GetxController {
  var isLoading = false.obs;
  var batchReports = <Map<String, dynamic>>[].obs;
  var selectedBatch = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadBatchReports();
  }

  Future<void> loadBatchReports() async {
    try {
      isLoading.value = true;
      // TODO: Load batch performance reports from API
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load batch performance reports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectBatch(Map<String, dynamic> batch) {
    selectedBatch.value = batch;
  }

  void refreshReports() {
    loadBatchReports();
  }
}

