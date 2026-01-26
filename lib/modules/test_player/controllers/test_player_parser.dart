
import 'dart:convert';

import 'package:flutter/services.dart';

// ============================================================
// API PARSER - Standalone Class
// ============================================================


enum QuestionType {
  mcqSingle,
  mcqMultiple,
  matchTheFollowing,
  numerical,
  subjective,
  trueFalse,
  singleDropdown,
  multiDropdown,
  textType,
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
  final String? questionHtml;

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
    this.questionHtml,
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



class TestApiParser {


  static String fixBrokenJson(String raw) {
    return raw
        .replaceAll('\t', '\\t')
        .replaceAll('\n\n', '\n')   // newline
        .replaceAll('\r', '\\r')   // carriage return
    // Fix HTML attributes
        .replaceAllMapped(
      RegExp(r'style="([^"]*)"'),
          (m) => 'style=\\"${m[1]}\\"',
    )
        .replaceAllMapped(
      RegExp(r'align="([^"]*)"'),
          (m) => 'align=\\"${m[1]}\\"',
    )

    // ✅ Fix ONLY single-backslash LaTeX (ignore already-escaped \\)
        .replaceAllMapped(
      RegExp(r'(?<!\\)\\([a-zA-Z()])'),
          (m) => '\\\\${m[1]}',
    );
  }

  static bool _isDoubleEncoded(String s) {
    return s.trim().startsWith('"') && s.contains('\\n');
  }

  static Future<Map<String, dynamic>> loadQuestionsJson() async {
    final rawString = await rootBundle.loadString('assets/test.json');

    final fixedString = fixBrokenJson(rawString);

    // Handle double-encoded JSON
    if (_isDoubleEncoded(fixedString)) {
      final inner = json.decode(fixedString);
      return json.decode(inner) as Map<String, dynamic>;
    }

    return json.decode(fixedString) as Map<String, dynamic>;
  }


  // Parse from JSON string
  static Future<List<QuestionCategory>> parseFromJsonString(String jsonString) async {
    try {
      final Map<String, dynamic> jsonData =await loadQuestionsJson();
      return parseApiResponse(jsonData);
    } catch (e) {
      print('Error parsing JSON string: $e');
      return [];
    }
  }

  // Main parser for API response
  static List<QuestionCategory> parseApiResponse(Map<String, dynamic> jsonData) {
    try {

      final List<dynamic> dataList = jsonData['data'] as List<dynamic>;
      if (dataList.isEmpty) return [];

      final testData = dataList[0] as Map<String, dynamic>;
      final List<dynamic> questionsJson = testData['questions'] as List<dynamic>;

      // Group questions by subtopic
      final Map<String, List<Question>> questionsBySubtopic = {};

      for (int i = 0; i < questionsJson.length; i++) {
        final qJson = questionsJson[i] as Map<String, dynamic>;

        // Get subtopic name for grouping
        final subtopicName = (qJson['subtopicId'] as Map<String, dynamic>?)?['subtopicName'] as String? ??
            (testData['subtopic'] as Map<String, dynamic>?)?['subtopicName'] as String? ??
            'General';

        // Extract question type from API
        final questionTypeFromApi = qJson['questionType'] as String? ?? 'mcq_single';

        // Parse to our QuestionType enum
        final parsedType = _parseQuestionType(questionTypeFromApi);

        final question = Question(
          number: i + 1,
          text: qJson['questionText'] as String? ?? '',
          questionHtml: qJson['questionHtml'] as String?,
          type: parsedType,
          options: _parseOptions(qJson['options'] as List<dynamic>? ?? []),
          status: QuestionStatus.notVisited,
        );

        questionsBySubtopic.putIfAbsent(subtopicName, () => []).add(question);
      }

      // Convert to categories
      final List<QuestionCategory> categories = [];
      int categoryIndex = 0;

      questionsBySubtopic.forEach((subtopicName, questions) {
        categories.add(QuestionCategory(
          id: 'category_$categoryIndex',
          name: subtopicName,
          questionCount: questions.length,
          questions: questions,
        ));
        categoryIndex++;
      });

      return categories;
    } catch (e) {
      print('Error parsing API response: $e');
      return [];
    }
  }

  // Parse question type from API string to enum
  static QuestionType _parseQuestionType(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'mcq_single':
        return QuestionType.mcqSingle;
      case 'mcq_multiple':
        return QuestionType.mcqMultiple;
      case 'match_the_following':
      case 'maq':
        return QuestionType.matchTheFollowing;
      case 'integer':
      case 'numerical':
        return QuestionType.numerical;
      case 'short_answer':
        return QuestionType.textType;
      case 'subjective':
        return QuestionType.subjective;
      case 'true_false':
      case 'boolean':
        return QuestionType.trueFalse;
      case 'single_dropdown':
      case 'dropdown':
        return QuestionType.singleDropdown;
      case 'multi_dropdown':
        return QuestionType.multiDropdown;
      default:
        return QuestionType.mcqSingle; // Default fallback
    }
  }

  // Parse options from API
  static List<String> _parseOptions(List<dynamic> optionsJson) {
    return optionsJson
        .map((opt) {
      final optMap = opt as Map<String, dynamic>;
      return optMap['textHtml'] as String? ??
          optMap['text'] as String? ??
          '';
    })
        .where((text) => text.isNotEmpty)
        .toList();
  }

  String normalizeQuestionHtml(String input) {
    return input
    // Fix escaped LaTeX brackets
        .replaceAll(r'\\(', r'\(')
        .replaceAll(r'\\)', r'\)')

    // Fix escaped square brackets
        .replaceAll(r'\\[', r'\[')
        .replaceAll(r'\\]', r'\]')

    // Replace smart minus with normal minus
        .replaceAll('−', '-')

    // Replace pi symbol
        .replaceAll('π', r'\pi')

    // Replace union symbol
        .replaceAll('∪', r'\cup')

    // Fix common inverse trig issues
        .replaceAll('sin−1', r'\sin^{-1}')
        .replaceAll('cos−1', r'\cos^{-1}')
        .replaceAll('tan−1', r'\tan^{-1}')
        .replaceAll('cot−1', r'\cot^{-1}')
        .replaceAll('sec−1', r'\sec^{-1}')
        .replaceAll('cosec−1', r'\cosec^{-1}');
  }

}