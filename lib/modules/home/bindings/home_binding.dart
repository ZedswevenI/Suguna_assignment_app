import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/home/controllers/home_controller.dart';
import 'package:suguna_teachers_app/modules/timetable/controllers/timetable_controller.dart';
import 'package:suguna_teachers_app/modules/batch_control/controllers/batch_control_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TimetableController());
    Get.lazyPut(() => BatchControlController());
  }
}
