import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/phase_plan/controllers/phase_plan_controller.dart';

class PhasePlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhasePlanController());
  }
}

