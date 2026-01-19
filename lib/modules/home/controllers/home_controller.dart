import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum HomeViewType { timetable, batchControl }

class HomeController extends GetxController {
  var isLoading = false.obs;
  final GetStorage _storage = GetStorage();
  var currentView = HomeViewType.timetable.obs; // Default to timetable

  void showTimetable() {
    currentView.value = HomeViewType.timetable;
  }

  void showBatchControl() {
    currentView.value = HomeViewType.batchControl;
  }

  void logout() {
    // Clear storage
    _storage.remove('auth_token');
    _storage.remove('user_data');

    // Navigate to login (you can add login route later)
    // For now, just clear and stay on home
    Get.snackbar(
      'Logout',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
