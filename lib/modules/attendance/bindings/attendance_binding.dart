import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/attendance/controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceController());
  }
}

