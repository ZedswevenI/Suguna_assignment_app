import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/assignment_instructions/controllers/assignment_instructions_controller.dart';

class AssignmentInstructionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssignmentInstructionsController());
  }
}
