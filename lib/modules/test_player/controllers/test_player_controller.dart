
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_parser.dart';
import '../../../data/models/subject_model.dart';
import '../views/test_review_view.dart';

class TestPlayerController extends GetxController {

  final Rx<SubjectModel?> selectedSubject = Rx<SubjectModel?>(null);
  void updateView() => update(['palette']);
  final textSize = 1.obs;
  List<QuestionCategory> categories = [];
  bool isLoading = true;


  @override
  void onInit() {
    super.onInit();
    // Load actual API data
    loadTestData(_getApiResponse());
    _startTimer();
  }

  // Method to load test data from API
  void loadTestData(String jsonString) async {
    isLoading = true;
    updateView();
    categories.clear();
    categories.addAll(await TestApiParser.parseFromJsonString(jsonString));
    isLoading = false;
    updateView();
  }



  // Actual API response from your server
  String _getApiResponse() {

    return '''
    
    ''';
  }

  //
  // final categories = <QuestionCategory>[
  //   QuestionCategory(
  //     id: 'algebra',
  //     name: 'Algebra',
  //     questionCount: 15,
  //     questions: [
  //       Question(
  //         number: 1,
  //         text: 'Exponents with their correct number of digits : \\(\\log 2 = 0.301 \\\\ \\log 3 = 0.4771\\) COLUMN - ICOLUMN - II',
  //         type: QuestionType.mcqSingle,
  //         options: ['\\(3 \\log 5 + 2 \\log 4 - \\log 2\\) (P) 4', '\\(l o g_{625} \\sqrt{5}\\) (Q) \\(3^{\\frac{1}{2}}\\)', '\\(l o g_{3} x = \\frac{1}{2}\\) (R) \\(\\frac{1}{8}\\)', '\\(\\log \\left(\\right. 3 x - 2 \\left.\\right) = 1\\) (S) 3'],
  //       ),
  //       Question(
  //         number: 2,
  //         text: 'Exponents with their correct number of digits : \\(\\log 2 = 0.301 \\\\ \\log 3 = 0.4771\\) COLUMN - ICOLUMN - II',
  //         type: QuestionType.mcqMultiple,
  //         options: ['\\(\\log \\left(\\right. 3 x - 2 \\left.\\right) = 1\\) (S) 3', '\\(l o g_{3} x = \\frac{1}{2}\\) (R) \\(\\frac{1}{8}\\)', '\\(l o g_{625} \\sqrt{5}\\) (Q) \\(3^{\\frac{1}{2}}\\)', '\\(3 \\log 5 + 2 \\log 4 - \\log 2\\) (P) 4',],
  //         selectedAnswers: [],
  //       ),
  //       Question(
  //         number: 3,
  //         text: 'Match the following algebraic terms with their types:',
  //         type: QuestionType.matchTheFollowing,
  //         matchPairs: [
  //           MatchPair(left: '3x²', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
  //           MatchPair(left: '5', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
  //           MatchPair(left: '2x', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
  //         ],
  //         matchAnswers: {},
  //       ),
  //       Question(
  //         number: 4,
  //         text: 'Ratio of any two sides of an equilateral \\(\\triangle\\) is always ____________',
  //         type: QuestionType.numerical,
  //         minRange: 0,
  //         maxRange: 100,
  //       ),
  //       Question(
  //         number: 5,
  //         text: 'Is the equation x + 5 = 5 + x an example of commutative property?',
  //         type: QuestionType.trueFalse,
  //         options: ['True', 'False'],
  //       ),
  //       Question(
  //         number: 6,
  //         text: 'What is the degree of polynomial 3x³ + 2x² - 5x + 1?',
  //         type: QuestionType.singleDropdown,
  //         options: ['0', '1', '2', '3', '4'],
  //       ),
  //       Question(
  //         number: 7,
  //         text: 'Select all valid operations that preserve equality:',
  //         type: QuestionType.multiDropdown,
  //         options: ['Add same number to both sides', 'Multiply by zero', 'Divide by same non-zero number', 'Square both sides'],
  //         selectedAnswers: [],
  //       ),
  //       Question(
  //         number: 8,
  //         text: 'Enter the factored form of x² - 9',
  //         type: QuestionType.textType,
  //       ),
  //       Question(
  //         number: 9,
  //         text: 'Explain the steps to solve a quadratic equation using the quadratic formula.',
  //         type: QuestionType.subjective,
  //       ),
  //       ...List.generate(6, (i) => Question(
  //         number: i + 10,
  //         text: 'Sample algebra question ${i + 10}',
  //         type: QuestionType.mcqSingle,
  //         options: ['Option A', 'Option B', 'Option C', 'Option D'],
  //       )),
  //     ],
  //   ),
  //   QuestionCategory(
  //     id: 'graphs',
  //     name: 'Graphs',
  //     questionCount: 3,
  //     questions: [
  //       Question(
  //         number: 16,
  //         text: 'What is the slope of a horizontal line?',
  //         type: QuestionType.numerical,
  //         minRange: -10,
  //         maxRange: 10,
  //       ),
  //       Question(
  //         number: 17,
  //         text: 'Comprehension Logarithmic Inequalities statement \\(0 < a < 1\\) \\(l o g_{a} b \\geq l o g_{a} c \\Rightarrow b \\leq c\\) \\(l o g_{a} b \\geq c \\Rightarrow b \\leq_{a} c a >\\) 1 \\(l o g_{a} b \\geq l o g_{a} c \\Rightarrow b \\geq c > 0\\) \\(l o g_{a} b \\geq c \\Rightarrow b \\geq a^{c}\\) -- * -- Question :Which one of the following is least',
  //         type: QuestionType.trueFalse,
  //         options: ['True', 'False'],
  //       ),
  //       Question(
  //         number: 18,
  //         text: 'Describe how to find the equation of a line given two points.',
  //         type: QuestionType.subjective,
  //       ),
  //     ],
  //   ),
  //   QuestionCategory(
  //     id: 'theory',
  //     name: 'Theory',
  //     questionCount: 2,
  //     questions: [
  //       Question(
  //         number: 19,
  //         text: 'What does the Fundamental Theorem of Algebra state?',
  //         type: QuestionType.mcqSingle,
  //         options: [
  //           'Every polynomial has at least one root',
  //           'All polynomials are factorable',
  //           'Algebra is fundamental',
  //           'None of the above'
  //         ],
  //       ),
  //       Question(
  //         number: 20,
  //         text: 'Explain the concept of mathematical induction.',
  //         type: QuestionType.subjective,
  //       ),
  //     ],
  //   ),
  // ];

  void selectAnswer(String answer) {
    final question = currentQuestion;

    switch (question.type) {
      case QuestionType.mcqSingle:
      case QuestionType.trueFalse:
      case QuestionType.singleDropdown:
        question.selectedAnswer = answer;
        print("Selected one ${answer}");
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
    if (currentQuestion.selectedAnswer != null) {
      currentQuestion.status = QuestionStatus.answered;
    } else {
      currentQuestion.status = QuestionStatus.notAnswered;
    }
    _goToNextQuestion();
  }

  void clearResponse() {
    final question = currentQuestion;
    question.selectedAnswer = null;
    question.selectedAnswers = null;
    question.matchAnswers = null;
    question.numericalAnswer = null;
    question.textAnswer = null;

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
    updateView();
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
    if (currentQuestionIndex.value < currentCategory.questions.length - 1) {
      currentQuestionIndex.value++;
    } else if (currentCategoryIndex.value < categories.length - 1) {
      currentCategoryIndex.value++;
      currentQuestionIndex.value = 0;
    }
    updateView();
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
    submitTest();
  }

  void submitTest() {
    _timer?.cancel();
    // API submit call here
  }

  // ================= UI HELPERS =================
  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
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
  Map<String, String> correctAnswersMap = {}; // Will be populated from parser

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
        final correctNum = double.tryParse(correctAnswer);
        return question.numericalAnswer == correctNum;

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
    print("Is correct ${correctAnswersMap['question_${question.number}']} ${question.selectedAnswer}");
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
    return correctAnswersMap['question_${question.number}'] ?? 'N/A';
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

      default:
        return 'Not Answered';
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
        'timeSpent': formattedTime,
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

    final percentage = (correct / allQuestions.length) * 100;

    return {
      'total': allQuestions.length,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'percentage': percentage,
      'timeSpent': formattedTime,
    };
  }

  /// Alias for compatibility with result view
  bool isCorrect(Question question) {
    return isQuestionCorrect(question);
  }

  /// Complete test and show results
  void completeTest() {
    _timer?.cancel();
    _stopBlinking();
    isTestCompleted.value = true;
    reviewIndex.value = 0;

    // Navigate to result screen
    // Get.to(() => TestResultView());
    Get.off(() => const TestResultView());

}

  /// Submit test results to server
  Future<void> submitTestResults() async {
    try {
      final results = _prepareResultsForSubmission();

      // TODO: Replace with your actual API call
      // final _apiService = ServiceLocator.get<AssignmentApiServices>();
      // await _apiService.submitTestResults(results);

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

      default:
        return '';
    }
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
