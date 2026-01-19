import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/question_model.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';

class TestPlayerController extends GetxController {
  final questions = <QuestionModel>[].obs;
  final currentQuestionIndex = 0.obs;
  final selectedAnswerIndex = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  void loadQuestions() {
    questions.value = MockDataService.getQuestions();
    if (questions.isNotEmpty) {
      _loadCurrentQuestion();
    }
  }

  void _loadCurrentQuestion() {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion != null) {
      selectedAnswerIndex.value = currentQuestion.userAnswerIndex;
      // Mark as visited
      if (!currentQuestion.isVisited) {
        final index = currentQuestionIndex.value;
        questions[index] = QuestionModel(
          id: currentQuestion.id,
          questionNumber: currentQuestion.questionNumber,
          question: currentQuestion.question,
          options: currentQuestion.options,
          correctAnswerIndex: currentQuestion.correctAnswerIndex,
          userAnswerIndex: currentQuestion.userAnswerIndex,
          isMarked: currentQuestion.isMarked,
          isVisited: true,
          isAnswered: currentQuestion.isAnswered,
          type: currentQuestion.type,
          marks: currentQuestion.marks,
          userMarks: currentQuestion.userMarks,
        );
      }
    }
  }

  QuestionModel? getCurrentQuestion() {
    if (currentQuestionIndex.value >= 0 &&
        currentQuestionIndex.value < questions.length) {
      return questions[currentQuestionIndex.value];
    }
    return null;
  }

  void selectAnswer(int answerIndex) {
    selectedAnswerIndex.value = answerIndex;
    final index = currentQuestionIndex.value;
    final currentQuestion = questions[index];
    questions[index] = QuestionModel(
      id: currentQuestion.id,
      questionNumber: currentQuestion.questionNumber,
      question: currentQuestion.question,
      options: currentQuestion.options,
      correctAnswerIndex: currentQuestion.correctAnswerIndex,
      userAnswerIndex: answerIndex,
      isMarked: currentQuestion.isMarked,
      isVisited: true,
      isAnswered: true,
      type: currentQuestion.type,
      marks: currentQuestion.marks,
      userMarks: currentQuestion.userMarks,
    );
  }

  void goToQuestion(int questionNumber) {
    final index = questionNumber - 1;
    if (index >= 0 && index < questions.length) {
      currentQuestionIndex.value = index;
      _loadCurrentQuestion();
    }
  }

  void saveAndNext() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      _loadCurrentQuestion();
    }
  }

  void clearAnswer() {
    selectedAnswerIndex.value = null;
    final index = currentQuestionIndex.value;
    final currentQuestion = questions[index];
    questions[index] = QuestionModel(
      id: currentQuestion.id,
      questionNumber: currentQuestion.questionNumber,
      question: currentQuestion.question,
      options: currentQuestion.options,
      correctAnswerIndex: currentQuestion.correctAnswerIndex,
      userAnswerIndex: null,
      isMarked: currentQuestion.isMarked,
      isVisited: true,
      isAnswered: false,
      type: currentQuestion.type,
      marks: currentQuestion.marks,
      userMarks: currentQuestion.userMarks,
    );
  }

  void markQuestion() {
    final index = currentQuestionIndex.value;
    final currentQuestion = questions[index];
    questions[index] = QuestionModel(
      id: currentQuestion.id,
      questionNumber: currentQuestion.questionNumber,
      question: currentQuestion.question,
      options: currentQuestion.options,
      correctAnswerIndex: currentQuestion.correctAnswerIndex,
      userAnswerIndex: currentQuestion.userAnswerIndex,
      isMarked: !currentQuestion.isMarked,
      isVisited: true,
      isAnswered: currentQuestion.isAnswered,
      type: currentQuestion.type,
      marks: currentQuestion.marks,
      userMarks: currentQuestion.userMarks,
    );
  }

  void markAndNext() {
    markQuestion();
    saveAndNext();
  }

  void submit() {
    Get.toNamed(AppRoutes.testAnalysis, arguments: questions.toList());
  }

  void showReport() {
    Get.toNamed(AppRoutes.questionReview);
  }

  void exit() {
    Get.back();
  }
}
