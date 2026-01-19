import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/batch_performance_report/controllers/batch_performance_report_controller.dart';

class BatchPerformanceReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BatchPerformanceReportController());
  }
}

