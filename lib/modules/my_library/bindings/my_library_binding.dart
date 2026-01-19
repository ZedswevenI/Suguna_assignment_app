import 'package:get/get.dart';
import 'package:suguna_teachers_app/modules/my_library/controllers/my_library_controller.dart';

class MyLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyLibraryController());
  }
}

