import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/batch_control/controllers/batch_control_controller.dart';

class BatchControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BatchControlController());
  }
}

