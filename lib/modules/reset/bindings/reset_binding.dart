import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/reset/controllers/reset_controller.dart';

class ResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetController());
  }
}
