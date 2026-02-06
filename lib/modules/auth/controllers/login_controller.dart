import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/resources/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/assigment_api_services.dart';
import '../../../core/services/service_locator.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController(text: '9051642680002');
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var loginSuccess = false.obs;

  final _apiService = ServiceLocator.get<AssignmentApiServices>();


  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void gotoLogin(BuildContext? context) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(usernameController.text);
      if(response['status']) {
        Get.toNamed(AppRoutes.home,arguments: response);
      } else {
        Get.snackbar('Error', response['message']);
      }
    } catch (e) {
      print("Response cae ${e}");
      Get.snackbar('Error', "$e");
    } finally {
      isLoading.value = false;
    }
  }
}
