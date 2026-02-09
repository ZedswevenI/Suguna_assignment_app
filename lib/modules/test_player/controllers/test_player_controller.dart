
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/services/sessions.dart';
import 'package:suguna_assignment_app/modules/test_analysis/views/test_analysis_view.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_parser.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/services/store_service.dart';
import '../../topic_assignments/controllers/topic_assignments_controller.dart';
import '../views/test_review_view.dart';

class TestPlayerController extends GetxController {
  final TextEditingController numericalController = TextEditingController();
  final Rx<SubjectModel?> selectedSubject = Rx<SubjectModel?>(null);
  void updateView() => update(['palette']);
  void updateNewView() => update(['new']);

  final textSize = 1.obs;
  List<QuestionCategory> categories = [];
  bool isLoading = true;

  final storage = Get.find<StorageService>();
  late String currentTestId;
  final bookmarkedQuestions = <String>{}.obs;

  Map<String,dynamic> selectedQuestions = {};

  @override
  void onInit() {
    super.onInit();
    // Load actual API data
    initData();
  }
  Future<void> initData() async {
    // final args = Get.arguments;
    if (Session.instance.storedData != null) {
      if(!Session.instance.isRetest) {
        currentTestId = Session.instance.storedData!['testId'];
        final stored = Session.instance.storedData!['storedData'];
        categories = await TestApiParser.parseFromJsonString(
          stored['testJson'],
        );
        selectedQuestions = stored['testJson'];
        correctAnswersMap = Map<String, dynamic>.from(stored['result']);
        _restoreUserAnswers(stored['result']['answers']);
        _loadBookmarks();
        updateNewView();
      } else {
        takeRetest();
      }
    } else {
      startTestAgain();
    }
  }

  void _restoreUserAnswers(List<dynamic> savedAnswers) {
    final allQuestions = getAllQuestions();
    for (var saved in savedAnswers) {
      final number = saved['questionNumber'];
      final question =
      allQuestions.firstWhere((q) => q.number == number);

      final userAnswer = saved['userAnswer'];

      switch (question.type) {
        case QuestionType.mcqSingle:
        case QuestionType.trueFalse:
        case QuestionType.singleDropdown:
          question.selectedAnswer =
          userAnswer.isNotEmpty ? userAnswer : null;
          break;

        case QuestionType.mcqMultiple:
        case QuestionType.multiDropdown:
          question.selectedAnswers =
          userAnswer.isNotEmpty ? userAnswer.split(';') : [];
          break;

        case QuestionType.numerical:
          question.numericalAnswer =
              double.tryParse(userAnswer);
          break;

        case QuestionType.textType:
        case QuestionType.subjective:
          question.textAnswer = userAnswer;
          break;

        case QuestionType.matchTheFollowing:
          final map = <String, String>{};
          for (var pair in userAnswer.split(';')) {
            final parts = pair.split(':');
            if (parts.length == 2) {
              map[parts[0]] = parts[1];
            }
          }
          question.matchAnswers = map;
          break;
      }
    }
  }

  void startTestAgain() {
    final args = Get.arguments;
    try {
      currentTestId = args['testId'];
      selectedQuestions = TopicAssignmentsController.to.selectedQuestions  ?? {};
      loadTestData(_getApiResponse());
      _startTimer();
    } catch (e){
      selectedQuestions = TopicAssignmentsController.to.selectedQuestions  ?? {};
      loadTestData(_getApiResponse());
      _startTimer();
    }
  }


   void takeRetest() async {
     isLoading = true;
     updateView();
     categories.clear();
     currentTestId = Session.instance.storedData!['testId'];
     selectedQuestions = Session.instance.storedData!['storedData']['testJson'];
     final Map<String, dynamic> jsonData = selectedQuestions;
     categories.addAll(await TestApiParser.parseFromJsonString(jsonData));
     isLoading = false;
     _startTimer();
     updateView();
  }

  // Method to load test data from API
  void loadTestData(String jsonString) async {
    isLoading = true;
    updateView();
    categories.clear();
    final Map<String, dynamic> jsonData = TopicAssignmentsController.to.selectedQuestions ?? {};
    categories.addAll(await TestApiParser.parseFromJsonString(jsonData));
    isLoading = false;
    updateView();
  }



  // Actual API response from your server
  String _getApiResponse() {

    return '''
    
    ''';
  }

  void selectAnswer(String answer) {
    final question = currentQuestion;

    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
        question.selectedAnswer = answer;
        break;
      case QuestionType.mcqMultiple:
      case QuestionType.multiDropdown:
        question.selectedAnswers ??= [];
        if (question.selectedAnswers!.contains(answer)) {
          question.selectedAnswers!.remove(answer);
        } else {
          question.selectedAnswers!.add(answer);
        }
        break;
      default:
        break;
    }

    if (question.status == QuestionStatus.notVisited) {
      question.status = QuestionStatus.answered;
    }
    updateView();
  }


  void setTextAnswer(String text) {
    currentQuestion.textAnswer = text;
    if (currentQuestion.status == QuestionStatus.notVisited) {
      currentQuestion.status = QuestionStatus.answered;
    }
    updateView();
  }

  void selectMatch(String left, String right) {
    currentQuestion.matchAnswers ??= {};
    currentQuestion.matchAnswers![left] = right;
    if (currentQuestion.status == QuestionStatus.notVisited) {
      currentQuestion.status = QuestionStatus.answered;
    }
    updateView();
  }

  void setNumericalAnswer(double value) {
    currentQuestion.numericalAnswer = value;
    if (currentQuestion.status == QuestionStatus.notVisited) {
      currentQuestion.status = QuestionStatus.answered;
    }
    updateView();
  }

  final currentCategoryIndex = 0.obs;
  final currentQuestionIndex = 0.obs;

  void setTextSize(int size) {
    textSize.value = size;
    updateView();
  }

  double getQuestionFontSize() {
    switch (textSize.value) {
      case 0:
        return 14.0; // Small - A
      case 1:
        return 16.0; // Medium - A+
      case 2:
        return 18.0; // Large - A++
      default:
        return 16.0;
    }

  }

  double getOptionFontSize() {
    switch (textSize.value) {
      case 0:
        return 13.0; // Small
      case 1:
        return 15.0; // Medium
      case 2:
        return 17.0; // Large
      default:
        return 17.0;
    }
  }


  QuestionCategory get currentCategory => categories[currentCategoryIndex.value];
  Question get currentQuestion => currentCategory.questions[currentQuestionIndex.value];

  void selectCategory(int index) {
    currentCategoryIndex.value = index;
    currentQuestionIndex.value = 0;
  }

  void selectQuestion(int categoryIndex, int questionIndex) {
    currentCategoryIndex.value = categoryIndex;
    currentQuestionIndex.value = questionIndex;
    _syncNumericalField();
    updateView();
  }

  // void selectAnswer(String answer) {
  //   currentQuestion.selectedAnswer = answer;
  //   if (currentQuestion.status == QuestionStatus.notVisited) {
  //     currentQuestion.status = QuestionStatus.answered;
  //   }
  //   updateView();
  // }

  void saveAndNext() {
    final question = currentQuestion;

    bool isAnswered = false;

    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
        isAnswered = question.selectedAnswer != null;
        break;

      case QuestionType.mcqMultiple:
      case QuestionType.multiDropdown:
        isAnswered =
            question.selectedAnswers != null &&
                question.selectedAnswers!.isNotEmpty;
        break;

      case QuestionType.matchTheFollowing:
        isAnswered =
            question.matchAnswers != null &&
                question.matchAnswers!.isNotEmpty &&
                question.matchAnswers!.length ==
                    question.matchPairs?.length;
        break;

      case QuestionType.numerical:
        isAnswered = question.numericalAnswer != null;
        break;

      case QuestionType.textType:
      case QuestionType.subjective:
        isAnswered =
            question.textAnswer != null &&
                question.textAnswer!.trim().isNotEmpty;
        break;
    }

    question.status =
    isAnswered ? QuestionStatus.answered : QuestionStatus.notAnswered;

    _goToNextQuestion();
  }

  void clearResponse() {
    final question = currentQuestion;
    question.selectedAnswer = null;
    question.selectedAnswers = null;
    question.matchAnswers = null;
    question.numericalAnswer = null;
    question.textAnswer = null;
    numericalController.clear();  // 👈 clears UI instantly

    if (question.status == QuestionStatus.answeredAndMarked) {
      question.status = QuestionStatus.markedForReview;
    }
   updateView();
  }

  void saveAndMarkForReview() {
    if (currentQuestion.selectedAnswer != null) {
      currentQuestion.status = QuestionStatus.answeredAndMarked;
    } else {
      currentQuestion.status = QuestionStatus.markedForReview;
    }
    _goToNextQuestion();
  }

  void markForReviewAndNext() {
    if (currentQuestion.selectedAnswer != null) {
      currentQuestion.status = QuestionStatus.answeredAndMarked;
    } else {
      currentQuestion.status = QuestionStatus.markedForReview;
    }
    _goToNextQuestion();
  }

  void previous() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    } else if (currentCategoryIndex.value > 0) {
      currentCategoryIndex.value--;
      currentQuestionIndex.value = currentCategory.questions.length - 1;
    }
    updateView();
  }

  void _goToNextQuestion() {
    numericalController.clear();
    if (currentQuestionIndex.value < currentCategory.questions.length - 1) {
      currentQuestionIndex.value++;
    } else if (currentCategoryIndex.value < categories.length - 1) {
      currentCategoryIndex.value++;
      currentQuestionIndex.value = 0;
    }
    _syncNumericalField();
    updateView();
  }

  void _syncNumericalField() {
    final question = currentQuestion;
    if (question.type == QuestionType.numerical) {
      if (question.numericalAnswer != null) {
        numericalController.text =
            question.numericalAnswer.toString();
      } else {
        numericalController.clear();
      }
    } else {
      numericalController.clear();
    }
  }

  Map<QuestionStatus, int> getCategoryStats(int categoryIndex) {
    final category = categories[categoryIndex];
    final stats = <QuestionStatus, int>{};
    for (var status in QuestionStatus.values) {
      stats[status] = category.questions.where((q) => q.status == status).length;
    }
    return stats;
  }

  bool isLatex(String text) {
    final latexPatterns = [
      r'\$.*?\$',              // $...$
      r'\\\(',                 // \(
      r'\\\)',                 // \)
      r'\\frac',               // \frac
      r'\\sqrt',               // \sqrt
      r'\\alpha|\\beta|\\gamma|\\delta|\\Delta',
      r'\^',                   // superscript
      r'_',                    // subscript
      r'\\begin\{.*?\}',       // environments
      r'\\end\{.*?\}',
    ];

    return latexPatterns.any(
          (pattern) => RegExp(pattern).hasMatch(text),
    );
  }


  //Timers
  static const int totalDurationSeconds = 30 * 60; // 45 minutes
  static const int warningThresholdSeconds = 5 * 60; // 5 minutes
  static const int blinkThresholdSeconds = 60; // last 1 minute

  final enableBlinkingTimer = true; // 🔥 ONE BOOLEAN (toggle anytime)
  final blinkOn = true.obs;
  Timer? _blinkTimer;

  final remainingSeconds = totalDurationSeconds.obs;
  final showFiveMinWarning = false.obs;

  Timer? _timer;


  @override
  void onClose() {
    _timer?.cancel();
    _stopBlinking();
    super.onClose();
  }

  // ================= TIMER LOGIC =================
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel();
        _onTimeUp();
        _stopBlinking();
        return;
      }

      remainingSeconds.value--;

      // 🔔 Show 5-minute warning once
      if (remainingSeconds.value == warningThresholdSeconds) {
        showFiveMinWarning.value = true;
        _showFiveMinuteWarning();
      }

      if (enableBlinkingTimer &&
          remainingSeconds.value == blinkThresholdSeconds) {
        _startBlinking();
      }
    });
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      blinkOn.toggle();
    });
  }

  void _stopBlinking() {
    _blinkTimer?.cancel();
    blinkOn.value = true;
  }


  void _onTimeUp() {
    Get.snackbar(
      'Time Up',
      'Your test time has ended',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    // TODO: auto submit test
    // submitTest();
  }

  void submitTest() {
    _timer?.cancel();
    Get.snackbar("Success", "Your has been submitted successfully",backgroundColor: Colors.green);
    // API submit call here
  }

  // ================= UI HELPERS =================
  String get formattedTime {
    final minutes = (remainingSeconds.value) ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ================= UI HELPERS =================
  String get takenTime {
    final minutes = (totalDurationSeconds - remainingSeconds.value) ~/ 60;
    final seconds = (totalDurationSeconds - remainingSeconds.value) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isLastFiveMinutes =>
      remainingSeconds.value <= warningThresholdSeconds;

  bool get isLastOneMinute => remainingSeconds.value <= 60;
  bool get isTimerCompleted => remainingSeconds.value <= 0;


  void _showFiveMinuteWarning() {
    Get.snackbar(
      'Hurry Up ⏰',
      'You have only 5 minutes left to complete the test',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF97316),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
    );
  }

  // ============================================================
// ADD THESE METHODS TO YOUR TestPlayerController CLASS
// ============================================================

// Add these variables at the top with your other state variables:
  final reviewIndex = 0.obs;
  final isTestCompleted = false.obs;
  Map<String, dynamic> correctAnswersMap = {}; // Will be populated from parser

// ============================================================
// RESULT & REVIEW METHODS
// ============================================================

  /// Get all questions across all categories
  List<Question> getAllQuestions() {
    return categories.expand((cat) => cat.questions).toList();
  }

  /// Get current question in review mode
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

  /// Navigate to specific question in review mode
  void goToReviewQuestion(int index) {
    reviewIndex.value = index;
    updateView();
  }

  /// Get total number of questions
  int get totalQuestions => getAllQuestions().length;

  /// Check if a question was skipped (not attempted)
  bool isQuestionSkipped(Question question) {
    return question.selectedAnswer == null &&
        (question.selectedAnswers?.isEmpty ?? true) &&
        (question.matchAnswers?.isEmpty ?? true) &&
        question.numericalAnswer == null &&
        (question.textAnswer?.isEmpty ?? true);
  }

  /// Check if a question is correct
  bool isQuestionCorrect(Question question) {
    // Get correct answer from storage
    final correctAnswer = correctAnswersMap['question_${question.number}'];
    if (correctAnswer == null) return false;

    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
      // For MCQ single, compare the selected answer's key (A, B, C, D)
        return question.selectedAnswer == correctAnswer;

      case QuestionType.mcqMultiple:
      case QuestionType.multiDropdown:
      // For multiple choice, split correct answers by semicolon
        final correctAnswers = correctAnswer.split(';').toSet();
        final userAnswers = question.selectedAnswers?.toSet() ?? {};
        return correctAnswers.toString() == userAnswers.toString();

      case QuestionType.numerical:
      // For numerical, parse and compare
      if(correctAnswer is bool) {
        final correctNum = double.tryParse('0');
        return question.numericalAnswer == correctNum;
      } else {
        final correctNum = double.tryParse(correctAnswer);
        return question.numericalAnswer == correctNum;
      }


      case QuestionType.textType:
      case QuestionType.subjective:
      // For text, do case-insensitive comparison
        return question.textAnswer?.toLowerCase().trim() ==
            correctAnswer.toLowerCase().trim();

      case QuestionType.matchTheFollowing:
      // For matching, compare all pairs
        if (question.matchAnswers == null) return false;
        // Parse expected format: "A:1;B:2;C:3"
        final expectedPairs = correctAnswer.split(';');
        for (var pair in expectedPairs) {
          final parts = pair.split(':');
          if (parts.length != 2) continue;
          final left = parts[0].trim();
          final right = parts[1].trim();
          if (question.matchAnswers![left] != right) return false;
        }
        return true;

      default:
        return false;
    }
  }

  /// Check if specific option is the correct answer
  bool isOptionCorrect(Question question, String option) {
    final correctAnswer = correctAnswersMap['question_${question.number}'];
    if (correctAnswer == null) return false;

    if (question.type == QuestionType.mcqMultiple) {
      final correctAnswers = correctAnswer.split(';');
      return correctAnswers.contains(option);
    }

    return option == correctAnswer;
  }

  /// Check if user selected this option
  bool isUserAnswer(Question question, String option) {
    if (question.type == QuestionType.mcqMultiple) {
      return question.selectedAnswers?.contains(option) ?? false;
    }
    return question.selectedAnswer == option;
  }

  /// Get correct answer text for display
  String getCorrectAnswer(Question question) {
    return correctAnswersMap['question_${question.number}'] is bool ? "0" : correctAnswersMap['question_${question.number}'] ?? 'N/A';
  }

  /// Get user's answer formatted for display
  String getUserAnswerDisplay(Question question) {
    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
        return question.selectedAnswer ?? 'Not Answered';

      case QuestionType.mcqMultiple:
      case QuestionType.multiDropdown:
        if (question.selectedAnswers == null || question.selectedAnswers!.isEmpty) {
          return 'Not Answered';
        }
        return question.selectedAnswers!.join(', ');

      case QuestionType.numerical:
        return question.numericalAnswer?.toString() ?? 'Not Answered';

      case QuestionType.textType:
      case QuestionType.subjective:
        return question.textAnswer?.isNotEmpty == true
            ? question.textAnswer!
            : 'Not Answered';

      case QuestionType.matchTheFollowing:
        if (question.matchAnswers == null || question.matchAnswers!.isEmpty) {
          return 'Not Answered';
        }
        return question.matchAnswers!.entries
            .map((e) => '${e.key} → ${e.value}')
            .join(', ');
      }
  }

  /// Get correct answer formatted for display
  String getCorrectAnswerDisplay(Question question) {
    final answer = correctAnswersMap['question_${question.number}'];
    if (answer == null) return 'N/A';

    switch (question.type) {
      case QuestionType.mcqMultiple:
        return answer.split(';').join(', ');

      case QuestionType.matchTheFollowing:
        return answer.split(';').map((pair) {
          final parts = pair.split(':');
          return '${parts[0]} → ${parts[1]}';
        }).join(', ');

      default:
        return answer;
    }
  }

  /// Get comprehensive test statistics
  Map<String, dynamic> getTestStatistics() {
    final allQuestions = getAllQuestions();
    if (allQuestions.isEmpty) {
      return {
        'total': 0,
        'correct': 0,
        'wrong': 0,
        'skipped': 0,
        'percentage': 0.0,
        'timeSpent': takenTime
      };
    }

    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (var question in allQuestions) {
      if (isQuestionSkipped(question)) {
        skipped++;
      } else if (isQuestionCorrect(question)) {
        correct++;
      } else {
        wrong++;
      }
    }
    String timeSpend = takenTime;
    if(Session.instance.storedData != null && !Session.instance.isRetest) {

      final minutes = Session.instance.storedData!['storedData']['result']['timeSpentSeconds'] ~/ 60;
      final seconds = Session.instance.storedData!['storedData']['result']['timeSpentSeconds'] % 60;
      timeSpend ='${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    final percentage = (correct / allQuestions.length) * 100;

    return {
      'total': allQuestions.length,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'percentage': percentage,
      'timeSpent': timeSpend,
    };
  }

  /// Alias for compatibility with result view
  bool isCorrect(Question question) {
    return isQuestionCorrect(question);
  }

  void completeTest() {
    final TextEditingController confirmController = TextEditingController();
    final RxBool isValid = false.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Confirm Submission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type SUBMIT below to confirm test submission.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              onChanged: (value) {
                isValid.value = value.trim().toUpperCase() == "SUBMIT";
              },
              decoration: InputDecoration(
                hintText: 'Type SUBMIT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: isValid.value
                ? () {
              Get.back();
              finalCompleteTest();
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
            ),
            child: const Text('Submit Test'),
          )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Complete test and show results
  void finalCompleteTest() {
    _timer?.cancel();
    _stopBlinking();
    isTestCompleted.value = true;
    reviewIndex.value = 0;

    // Navigate to result screen
    // Get.to(() => TestResultView());
    final Map<String, dynamic> results = _prepareResultsForSubmission();
    storage.save('test_$currentTestId', {
      "testJson": selectedQuestions,
      "result": results,
      "completed": true,
      "timestamp": DateTime.now().toIso8601String(),
    });
    // Get.off(() => const TestResultView());
    Get.off(() => const TestAnalysisView());
}

  /// Submit test results to server
  Future<void> submitTestResults() async {
    try {
      final results = _prepareResultsForSubmission();
      print('Results to submit: ${json.encode(results)}');

      Get.snackbar(
        'Success',
        'Test results submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back or to results page
      // Get.back();

    } catch (e) {
      print('Error submitting results: $e');
      Get.snackbar(
        'Error',
        'Failed to submit results. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Prepare results data for API submission
  Map<String, dynamic> _prepareResultsForSubmission() {
    final stats = getTestStatistics();
    final allQuestions = getAllQuestions();

    final answers = allQuestions.map((q) {
      return {
        'questionNumber': q.number,
        'questionId': 'question_${q.number}',
        'questionType': q.type.toString(),
        'userAnswer': _getUserAnswerForSubmission(q),
        'correctAnswer': correctAnswersMap['question_${q.number}'],
        'isCorrect': isQuestionCorrect(q),
        'isSkipped': isQuestionSkipped(q),
      };
    }).toList();

    return {
      'testId': '471', // Get from your test data
      'userId': 'USER_ID', // Get from auth
      'studentId': 'STUDENT_ID', // Get from auth
      'score': stats['correct'],
      'totalQuestions': stats['total'],
      'percentage': stats['percentage'],
      'correctAnswers': stats['correct'],
      'wrongAnswers': stats['wrong'],
      'skippedQuestions': stats['skipped'],
      'timeSpent': stats['timeSpent'],
      'timeSpentSeconds': totalDurationSeconds - remainingSeconds.value,
      'answers': answers,
      'completedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Get user answer in format suitable for API submission
  String _getUserAnswerForSubmission(Question question) {
    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
        return question.selectedAnswer ?? '';

      case QuestionType.mcqMultiple:
      case QuestionType.multiDropdown:
        return question.selectedAnswers?.join(';') ?? '';

      case QuestionType.numerical:
        return question.numericalAnswer?.toString() ?? '';

      case QuestionType.textType:
      case QuestionType.subjective:
        return question.textAnswer ?? '';

      case QuestionType.matchTheFollowing:
        return question.matchAnswers?.entries
            .map((e) => '${e.key}:${e.value}')
            .join(';') ?? '';
      }
  }

  Map<String, dynamic> getPerformanceReport() {
    final allQuestions = getAllQuestions();

    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (var question in allQuestions) {
      if (isQuestionSkipped(question)) {
        skipped++;
      } else if (isQuestionCorrect(question)) {
        correct++;
      } else {
        wrong++;
      }
    }

    const double positiveMarkPerQuestion = 3.0;
    const double negativeMarkPerQuestion = 1.0; // change if needed

    final double positiveMarks = correct * positiveMarkPerQuestion;
    final double negativeMarks = wrong * negativeMarkPerQuestion;
    final double totalScore = positiveMarks - negativeMarks;

    return {
      "totalQuestions": allQuestions.length,
      "correct": correct,
      "wrong": wrong,
      "skipped": skipped,
      "positiveMarks": positiveMarks,
      "negativeMarks": negativeMarks,
      "totalScore": totalScore,
    };
  }


  bool isBookmarked(String questionNumber) {
    return bookmarkedQuestions.contains(questionNumber);
  }

  void _loadBookmarks() {
    final stored = storage.read('bookmarks_$currentTestId');
    if (stored != null && stored is List) {
      bookmarkedQuestions.assignAll(
        stored.map((e) => e.toString()).toList(),
      );
    }
  }

  void toggleBookmark(String questionNumber) {
    if (bookmarkedQuestions.contains(questionNumber)) {
      bookmarkedQuestions.remove(questionNumber);
    } else {
      bookmarkedQuestions.add(questionNumber);
    }
    storage.save(
      'bookmarks_$currentTestId',
      bookmarkedQuestions.toList(),
    );
    updateNewView();
  }

// ============================================================
// UPDATE YOUR submitTest() METHOD
// ============================================================

// Replace your existing submitTest() with:
//   void submitTest() {
//     _timer?.cancel();
//     _stopBlinking();
//
//     // Show confirmation dialog
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Submit Test?'),
//         content: const Text(
//           'Are you sure you want to submit the test? You cannot change your answers after submission.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               completeTest();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4F46E5),
//             ),
//             child: const Text('Submit'),
//           ),
//         ],
//       ),
//     );
//   }

}
