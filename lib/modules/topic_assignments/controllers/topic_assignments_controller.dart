import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/models/topic_model.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/widgets/score_circle.dart';

import '../../../core/resources/app_strings.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/assigment_api_services.dart';
import '../../../core/services/service_locator.dart';
import '../views/topic_assignments_view.dart';

class TopicAssignmentsController extends GetxController {
  late final SubjectModel subject;
  final topics = <TopicModel>[].obs;
  final selectedTopicId = ''.obs;
  final isLoading = false.obs;
  final downloadingSubtopicIds = <String>{}.obs;
  final downloadedSubtopicIds = <String>{}.obs;
  final selectedSubtopicId = Rxn<String>();
  final selectedColumnKey = Rxn<String>();
  final _apiService = ServiceLocator.get<AssignmentApiServices>();
  Map<String,dynamic>? selectedQuestions ;
  final selectedTestId = Rxn<String>();

  static TopicAssignmentsController get to => Get.find();


  @override
  void onInit() {
    super.onInit();
    subject = Get.arguments as SubjectModel;
    loadTopics();
  }

  void loadTopics() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getAssignmentTopics(subject.name, 9);
      topics.value = mapTopicsFromApi(response);
      if (topics.isNotEmpty) {
        selectedTopicId.value = topics.first.id;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load topics');
    } finally {
      isLoading.value = false;
    }
  }

  List<TopicModel> mapTopicsFromApi(Map<String, dynamic> response) {
    final Map<String, dynamic> subtopicsByTopics =
    response['data']['subtopicsByTopics'];

    final List<TopicModel> topics = [];

    subtopicsByTopics.forEach((categoryName, subtopicsList) {
      final List<SubtopicModel> subtopics = [];

      for (final subtopic in subtopicsList) {
        final Map<String, List<AssignmentScore>> scores = {};

        for (final test in subtopic['test']) {
          final columnKey =
          normalizeExamCategory(test['examCategory']);

          scores.putIfAbsent(columnKey, () => []).add(
            AssignmentScore(
              testId: test['testId'],
              sortOrder: test['sortOrder'],
            ),
          );
        }

        // 🔥 Important: keep order stable (level-wise)
        scores.forEach((key, list) {
          list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        });

        subtopics.add(
          SubtopicModel(
            id: subtopic['subtopicId'],
            name: subtopic['subtopicName'],
            scores: scores,
          ),
        );
      }

      topics.add(
        TopicModel(
          id: categoryName,
          name: categoryName,
          subtopics: subtopics,
        ),
      );
    });

    return topics;
  }
  String normalizeExamCategory(String apiValue) {
    if (apiValue == 'JEE Mains') return 'JEE Main';
    return apiValue;
  }


  void selectTopic(String topicId) {
    selectedTopicId.value = topicId;
    selectedSubtopicId.value = null; // Clear selection when topic changes
    selectedColumnKey.value = null;
  }

  TopicModel? get selectedTopic {
    if (selectedTopicId.value.isEmpty) return null;
    try {
      return topics.firstWhere((t) => t.id == selectedTopicId.value);
    } catch (e) {
      return null;
    }
  }

  void onCircleTap(
      String subtopicId,
      String columnKey,
      String testId,
      ) async {
    final key = '$subtopicId-$columnKey-$testId';

    // 🔥 Mark selection immediately (for UI)
    selectedSubtopicId.value = subtopicId;
    selectedColumnKey.value = columnKey;
    selectedTestId.value = testId;

    // Already downloaded → just show CTA
    if (downloadedSubtopicIds.contains(key)) {
      return;
    }

    // Already downloading → ignore
    if (downloadingSubtopicIds.contains(key)) {
      return;
    }

    downloadingSubtopicIds.add(key);

    try {
      final response = await _apiService.loadQuestions(
        subject.name,
        9,
        testId,
      );

      downloadingSubtopicIds.remove(key);
      downloadedSubtopicIds.add(key);

      selectedQuestions = response;
    } catch (e) {
      downloadingSubtopicIds.remove(key);
      Get.snackbar('Error', 'Failed to load questions');
    }
  }

  void startAssignment() {
    if (selectedSubtopicId.value == null ||
        selectedColumnKey.value == null ||
        selectedTestId.value == null) {
      return;
    }

    Get.toNamed(
      AppRoutes.assignmentInstructions,
      arguments: {
        'subtopicId': selectedSubtopicId.value,
        'columnKey': selectedColumnKey.value,
        'testId': selectedTestId.value,
      },
    );

    // Clear selection
    selectedSubtopicId.value = null;
    selectedColumnKey.value = null;
    selectedTestId.value = null;
  }
  bool isSubtopicSelected(
      String subtopicId,
      String columnKey,
      String testId,
      ) {
    return selectedSubtopicId.value == subtopicId &&
        selectedColumnKey.value == columnKey &&
        selectedTestId.value == testId;
  }
  CircleState getCircleState(
      String subtopicId,
      String columnKey,
      String testId,
      ) {
    final key = '$subtopicId-$columnKey-$testId';

    if (downloadingSubtopicIds.contains(key)) {
      return CircleState.downloading;
    }
    if (downloadedSubtopicIds.contains(key)) {
      return CircleState.downloaded;
    }
    return CircleState.defaultState;
  }

  AssignmentStatus getAssignmentStatus(
      String subtopicId,
      String columnKey,
      String testId,
      ) {
    final key = '$subtopicId-$columnKey-$testId';

    if (downloadedSubtopicIds.contains(key)) {
      return AssignmentStatus.attempted;
    }

    if (downloadingSubtopicIds.contains(key)) {
      return AssignmentStatus.available;
    }

    return AssignmentStatus.notOpened;
  }

  ScoreLevel? getScoreLevel(
      String subtopicId,
      String columnKey,
      String testId,
      ) {
    final key = '$subtopicId-$columnKey-$testId';

    if (!downloadedSubtopicIds.contains(key)) {
      return null;
    }

    return null;
  }
}
