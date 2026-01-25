
import 'package:get/get.dart';

import '../../../data/models/subject_model.dart';

enum QuestionType {
  mcqSingle,           // MCQ - Single Answer
  mcqMultiple,         // MCQ - Multiple Answer
  MatchTheFollowing,   // MAQ (Match columns)
  numerical,           // Numerical Answer
  subjective,          // Subjective Type
  trueFalse,          // True/False
  singleDropdown,     // Single Select Dropdown
  multiDropdown,      // Multi Select Dropdown
  textType,           // Text Type
}

class MatchPair {
  final String left;
  final List<String> rightOptions;

  MatchPair({required this.left, required this.rightOptions});
}

class QuestionCategory {
  final String id;
  final String name;
  final int questionCount;
  final List<Question> questions;

  QuestionCategory({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.questions,
  });
}
class Question {
  final int number;
  final String text;
  final QuestionType type;
  final List<String> options;
  final List<MatchPair>? matchPairs; // For MAQ
  final double? minRange; // For numerical
  final double? maxRange; // For numerical

  // Answer storage
  String? selectedAnswer; // For single select
  List<String>? selectedAnswers; // For multiple select
  Map<String, String>? matchAnswers; // For MAQ
  double? numericalAnswer; // For numerical
  String? textAnswer; // For subjective/text

  QuestionStatus status;

  Question({
    required this.number,
    required this.text,
    required this.type,
    this.options = const [],
    this.matchPairs,
    this.minRange,
    this.maxRange,
    this.selectedAnswer,
    this.selectedAnswers,
    this.matchAnswers,
    this.numericalAnswer,
    this.textAnswer,
    this.status = QuestionStatus.notVisited,
  });
}
enum QuestionStatus {
  answered,
  notAnswered,
  markedForReview,
  answeredAndMarked,
  notVisited,
}


class TestPlayerController extends GetxController {

  final Rx<SubjectModel?> selectedSubject = Rx<SubjectModel?>(null);
  void updateView() => update(['palette']);

  final textSize = 1.obs;

  final categories = <QuestionCategory>[
    QuestionCategory(
      id: 'algebra',
      name: 'Algebra',
      questionCount: 15,
      questions: [
        Question(
          number: 1,
          text: 'What is the value of x in the equation 2x + 5 = 15?',
          type: QuestionType.mcqSingle,
          options: ['x = 3', 'x = 5', 'x = 7', 'x = 10'],
        ),
        Question(
          number: 2,
          text: 'Select all prime numbers from the following:',
          type: QuestionType.mcqMultiple,
          options: ['2', '4', '7', '9', '11', '15'],
          selectedAnswers: [],
        ),
        Question(
          number: 3,
          text: 'Match the following algebraic terms with their types:',
          type: QuestionType.MatchTheFollowing,
          matchPairs: [
            MatchPair(left: '3x²', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
            MatchPair(left: '5', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
            MatchPair(left: '2x', rightOptions: ['Constant', 'Linear', 'Quadratic', 'Cubic']),
          ],
          matchAnswers: {},
        ),
        Question(
          number: 4,
          text: 'Find the value of x² when x = 3',
          type: QuestionType.numerical,
          minRange: 0,
          maxRange: 100,
        ),
        Question(
          number: 5,
          text: 'Is the equation x + 5 = 5 + x an example of commutative property?',
          type: QuestionType.trueFalse,
          options: ['True', 'False'],
        ),
        Question(
          number: 6,
          text: 'What is the degree of polynomial 3x³ + 2x² - 5x + 1?',
          type: QuestionType.singleDropdown,
          options: ['0', '1', '2', '3', '4'],
        ),
        Question(
          number: 7,
          text: 'Select all valid operations that preserve equality:',
          type: QuestionType.multiDropdown,
          options: ['Add same number to both sides', 'Multiply by zero', 'Divide by same non-zero number', 'Square both sides'],
          selectedAnswers: [],
        ),
        Question(
          number: 8,
          text: 'Enter the factored form of x² - 9',
          type: QuestionType.textType,
        ),
        Question(
          number: 9,
          text: 'Explain the steps to solve a quadratic equation using the quadratic formula.',
          type: QuestionType.subjective,
        ),
        ...List.generate(6, (i) => Question(
          number: i + 10,
          text: 'Sample algebra question ${i + 10}',
          type: QuestionType.mcqSingle,
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
        )),
      ],
    ),
    QuestionCategory(
      id: 'graphs',
      name: 'Graphs',
      questionCount: 3,
      questions: [
        Question(
          number: 16,
          text: 'What is the slope of a horizontal line?',
          type: QuestionType.numerical,
          minRange: -10,
          maxRange: 10,
        ),
        Question(
          number: 17,
          text: 'A straight line passes through origin with positive slope. Is it in the first quadrant?',
          type: QuestionType.trueFalse,
          options: ['True', 'False'],
        ),
        Question(
          number: 18,
          text: 'Describe how to find the equation of a line given two points.',
          type: QuestionType.subjective,
        ),
      ],
    ),
    QuestionCategory(
      id: 'theory',
      name: 'Theory',
      questionCount: 2,
      questions: [
        Question(
          number: 19,
          text: 'What does the Fundamental Theorem of Algebra state?',
          type: QuestionType.mcqSingle,
          options: [
            'Every polynomial has at least one root',
            'All polynomials are factorable',
            'Algebra is fundamental',
            'None of the above'
          ],
        ),
        Question(
          number: 20,
          text: 'Explain the concept of mathematical induction.',
          type: QuestionType.subjective,
        ),
      ],
    ),
  ];

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
        return 12.0; // Small - A
      case 1:
        return 14.0; // Medium - A+
      case 2:
        return 16.0; // Large - A++
      default:
        return 16.0;
    }

  }

  double getOptionFontSize() {
    switch (textSize.value) {
      case 0:
        return 11.0; // Small
      case 1:
        return 13.0; // Medium
      case 2:
        return 15.0; // Large
      default:
        return 15.0;
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
}
