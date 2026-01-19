import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/models/topic_model.dart';
import 'package:suguna_assignment_app/data/services/mock_data_service.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/widgets/score_circle.dart';

class TopicAssignmentsController extends GetxController {
  late final SubjectModel subject;
  final topics = <TopicModel>[].obs;
  final selectedTopicId = ''.obs;
  final isLoading = false.obs;
  final downloadingSubtopicIds = <String>{}.obs;
  final downloadedSubtopicIds = <String>{}.obs;
  final selectedSubtopicId = Rxn<String>();
  final selectedColumnKey = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    subject = Get.arguments as SubjectModel;
    loadTopics();
  }

  void loadTopics() {
    isLoading.value = true;
    topics.value = MockDataService.getTopics(subject.id);
    if (topics.isNotEmpty) {
      selectedTopicId.value = topics.first.id;
    }
    isLoading.value = false;
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

  void onCircleTap(String subtopicId, String columnKey) {
    final key = '$subtopicId-$columnKey';
    
    // Check if already downloaded
    if (downloadedSubtopicIds.contains(key)) {
      // Show start assignment button
      selectedSubtopicId.value = subtopicId;
      selectedColumnKey.value = columnKey;
      return;
    }

    // Check if downloading
    if (downloadingSubtopicIds.contains(key)) {
      return;
    }

    // Start download
    downloadingSubtopicIds.add(key);

    // Simulate download
    Future.delayed(const Duration(seconds: 2), () {
      downloadingSubtopicIds.remove(key);
      downloadedSubtopicIds.add(key);
      // After download, select this subtopic to show start button
      selectedSubtopicId.value = subtopicId;
      selectedColumnKey.value = columnKey;
    });
  }

  void startAssignment() {
    if (selectedSubtopicId.value == null || selectedColumnKey.value == null) {
      return;
    }
    
    // Navigate to Assignment Instructions
    Get.toNamed(AppRoutes.assignmentInstructions, arguments: {
      'subtopicId': selectedSubtopicId.value,
      'columnKey': selectedColumnKey.value,
    });
    // Clear selection
    selectedSubtopicId.value = null;
    selectedColumnKey.value = null;
  }

  bool isSubtopicSelected(String subtopicId, String columnKey) {
    return selectedSubtopicId.value == subtopicId &&
        selectedColumnKey.value == columnKey;
  }

  CircleState getCircleState(String subtopicId, String columnKey) {
    final key = '$subtopicId-$columnKey';
    if (downloadingSubtopicIds.contains(key)) {
      return CircleState.downloading;
    }
    if (downloadedSubtopicIds.contains(key)) {
      return CircleState.downloaded;
    }
    return CircleState.defaultState;
  }
}
