import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/timetable/controllers/timetable_controller.dart';

class TimetableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TimetableController());
  }
}

