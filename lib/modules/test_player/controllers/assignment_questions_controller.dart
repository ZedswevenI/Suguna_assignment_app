

import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_controller.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_parser.dart';

class AssignmentQuestionsController extends GetxController {

  final _testPlayerController = TestPlayerController.to;

  final reviewIndex = TestPlayerController.to.reviewIndex.value.obs;
  final isTestCompleted = false.obs;

  @override
  void onInit() {
    reviewIndex.value = Get.arguments['index'];
    super.onInit();
  }

  List<Question> getAllQuestions() {
    return _testPlayerController.getAllQuestions();
  }

  void goToReviewQuestion(int index) {
    reviewIndex.value = index;
    update();
  }

  Question get currentReviewQuestion {
    final allQuestions = getAllQuestions();
    if (allQuestions.isEmpty || reviewIndex.value >= allQuestions.length) {
      return Question(
        questionId: '',
        number: 0,
        text: 'No question',
        type: QuestionType.mcqSingle,
      );
    }
    return allQuestions[reviewIndex.value];
  }

  /// Get total number of questions
  int get totalQuestions => getAllQuestions().length;

  /// Check if a question was skipped (not attempted)
  bool isQuestionSkipped(Question question) {
    return _testPlayerController.isQuestionSkipped(question);
  }

  /// Check if a question is correct
  bool isQuestionCorrect(Question question) {
    return _testPlayerController.isQuestionCorrect(question);
  }

  /// Check if specific option is the correct answer
  bool isOptionCorrect(Question question, String option) {
    return _testPlayerController.isOptionCorrect(question, option);
  }

  /// Check if user selected this option
  bool isUserAnswer(Question question, String option) {
    return _testPlayerController.isUserAnswer(question, option);
  }

  /// Get correct answer text for display
  String getCorrectAnswer(Question question) {
    return _testPlayerController.getCorrectAnswer(question);
  }

  /// Get user's answer formatted for display
  String getUserAnswerDisplay(Question question) {
    return _testPlayerController.getUserAnswerDisplay(question);
  }

  /// Get correct answer formatted for display
  String getCorrectAnswerDisplay(Question question) {
    return _testPlayerController.getCorrectAnswerDisplay(question);
  }

  /// Get comprehensive test statistics
  Map<String, dynamic> getTestStatistics() {
    return _testPlayerController.getTestStatistics();
  }

  Map<String, dynamic> getPerformanceReport() {
    return _testPlayerController.getPerformanceReport();
  }
}
