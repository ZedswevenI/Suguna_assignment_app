import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/question_review/controllers/question_review_controller.dart';

class QuestionReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuestionReviewController());
  }
}
