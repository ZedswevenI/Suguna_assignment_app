import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/assignment_control/controllers/assignment_control_controller.dart';

class AssignmentControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssignmentControlController());
  }
}

