import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/controllers/student_performance_report_controller.dart';

class StudentPerformanceReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentPerformanceReportController());
  }
}

