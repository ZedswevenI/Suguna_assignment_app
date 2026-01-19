import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/test_analysis/controllers/test_analysis_controller.dart';

class TestAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TestAnalysisController());
  }
}
