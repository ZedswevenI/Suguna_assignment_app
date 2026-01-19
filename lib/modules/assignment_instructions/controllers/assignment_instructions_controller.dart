import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';

class AssignmentInstructionsController extends GetxController {
  final instructions = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInstructions();
  }

  void loadInstructions() {
    instructions.value = MockDataService.getAssignmentInstructions();
  }

  void onAccept() {
    // Navigate to test player
    Get.toNamed(AppRoutes.testPlayer);
  }

  void onDecline() {
    Get.back();
  }
}
