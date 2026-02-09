import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/data/models/topic_model.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/widgets/score_circle.dart';
import 'package:suguna_assignment_app/data/services/network_service.dart';
import 'package:suguna_assignment_app/data/services/sessions.dart';
import '../../../core/services/assigment_api_services.dart';
import '../../../core/services/service_locator.dart';
import '../../../data/services/store_service.dart';
import '../../test_player/views/test_review_view.dart';
import '../views/topic_assignments_view.dart';

class TopicAssignmentsController extends GetxController {
  late final SubjectModel subject;
  final topics = <TopicModel>[].obs;
  final selectedTopicId = ''.obs;
  final isLoading = false.obs;
  final isTestCompleted = false.obs;
  final downloadingSubtopicIds = <String>{}.obs;
  final downloadedSubtopicIds = <String>{}.obs;
  final selectedSubtopicId = Rxn<String>();
  final selectedColumnKey = Rxn<String>();
  final _apiService = ServiceLocator.get<AssignmentApiServices>();
  Map<String, dynamic>? selectedQuestions;

  final selectedTestId = Rxn<String>();

  static TopicAssignmentsController get to => Get.find();
  late final Map<String, dynamic> loginResponse;
  final StorageService _storage = StorageService();
  final storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    loginResponse = (_storage.getUser() ?? {})['data'];
    subject = Get.arguments as SubjectModel;
    loadTopics();
  }

  Future<void> loadTopics() async {
    isLoading.value = true;

    try {
      final connectivityResult = await NetworkService.hasInternet();
      final String academicYear =
          loginResponse['admissionNo']?.toString() ?? '';
      final String entId =
          loginResponse['tenantId']?.toString() ?? '';
      final int classNo =
          loginResponse['classNo'] ?? '';

      // 🔑 Unique key per subject
      final String storageKey =
          "topics_${subject.id}_$classNo";

      if (connectivityResult) {
        // ================= ONLINE =================
        final response = await _apiService.getAssignmentTopics(
          subject.name,
          classNo,
          academicYear,
          entId,
        );
        // Save API response locally
        storage.saveTopics({
          storageKey: response
        });

        topics.value = mapTopicsFromApi(response);

        if (topics.isNotEmpty) {
          selectedTopicId.value = topics.first.id;
        }
      } else {
        final localData = storage.getGetTopics();
        if (localData != null) {
          if (localData.containsKey(storageKey)) {
            final cachedResponse = localData[storageKey];
            topics.value = mapTopicsFromApi(cachedResponse);
            if (topics.isNotEmpty) {
              selectedTopicId.value = topics.first.id;
            }
          } else {
            Get.snackbar(
              "Offline Mode",
              "Topics not cached for this subject yet",
            );
          }
        }
      }

      // ✅ After loading topics, scan storage for cached assignments
      _scanAndPopulateCachedAssignments();

    } catch (e,s) {
      Get.snackbar('Error', 'Failed to load topics: $e');
      print("Came to error ${e}");
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SCAN STORAGE FOR ALL CACHED ASSIGNMENTS
  // ============================================================

  void _scanAndPopulateCachedAssignments() {
    try {
      // Iterate through all topics and subtopics
      for (final topic in topics) {
        for (final subtopic in topic.subtopics) {
          subtopic.scores.forEach((category, subCategoryMap) {
            subCategoryMap.forEach((subCategory, assignments) {
              for (final assignment in assignments) {
                final key = '${subtopic.id}-$category-${assignment.testId}';
                final questionsStorageKey = "questions_$key";
                if (_storageKeyExists(questionsStorageKey)) {
                  downloadedSubtopicIds.add(key);
                }
              }
            });
          });
        }
      }
      // Trigger UI rebuild to show correct circle colors
      downloadedSubtopicIds.refresh();

    } catch (e) {
      print('❌ Error scanning storage: $e');
    }
  }

  // ============================================================
  // CHECK IF STORAGE KEY EXISTS
  // ============================================================

  bool _storageKeyExists(String key) {
    try {
      final data = storage.read(key);
      final exists = data != null;
      return exists;
    } catch (e) {
      return false;
    }
  }

  List<TopicModel> mapTopicsFromApi(Map<String, dynamic> response) {
    final Map<String, dynamic> subtopicsByTopics =
    response['data']['subtopicsByTopics'];

    final List<TopicModel> topics = [];

    subtopicsByTopics.forEach((categoryName, subtopicsList) {
      final List<SubtopicModel> subtopics = [];

      for (final subtopic in subtopicsList) {
        /// 🔥 Category -> SubCategory -> AssignmentScore
        final Map<String, Map<String, List<AssignmentScore>>> scores = {};

        for (final test in subtopic['test']) {
          final String examCategory = test['examCategory'] ?? '';
          final String examSubCategory = test['examSubCategory'] ?? '';
          scores
              .putIfAbsent(examCategory, () => {})
              .putIfAbsent(examSubCategory, () => [])
              .add(
            AssignmentScore(
              cgpa: test['cgpa'] == null ? null : double.parse(test['cgpa'].toString()) ,
              isEnabled: test['isEnabled'] ,
              status: test['status'] ,
              testId: test['testId'] ?? '',
              sortOrder: test['sortOrder'] ?? 0,
            ),
          );
        }

        /// 🔥 Sort each subcategory list
        scores.forEach((categoryKey, subCategoryMap) {
          subCategoryMap.forEach((subKey, list) {
            list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          });
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
    selectedSubtopicId.value = null;
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

  // ============================================================
  // IMPROVED CIRCLE TAP WITH BETTER STORAGE HANDLING
  // ============================================================

  void onCircleTap(
      String subtopicId,
      String columnKey,
      String testId,
      bool canDownload,
      SubtopicModel subtopic,
      String subCate
      ) async {

    if(!canDownload) {
      return;
    }

    Session.instance.selectedSub = subCate;
    Session.instance.selectedSubtopic = subtopic;

    // 🔑 Create unique key for this assignment
    final key = '$subtopicId-$columnKey-$testId';
    final questionsStorageKey = "questions_$key";
    final testDataStorageKey = "test_$testId";

    // ======= UI Selection =======
    selectedSubtopicId.value = subtopicId;
    selectedColumnKey.value = columnKey;
    selectedTestId.value = testId;

    try {
      final cachedQuestions = _readFromStorage(questionsStorageKey);
      final testDataKey = "test_${selectedTestId.value}";
      final stored = _readFromStorage(testDataKey);
      if(stored != null && stored is Map) {
        isTestCompleted.value = stored['completed'] == true || stored['data']?['completed'] == true;
      } else {
        isTestCompleted.value = false;
      }

      // Try to read stored test data
      if (cachedQuestions != null) {
        selectedQuestions = cachedQuestions;

        // ✅ Add to downloaded set if not already there
        if (!downloadedSubtopicIds.contains(key)) {
          downloadedSubtopicIds.add(key);
        }

        return;
      }


      // =========================
      // 2️⃣ PREVENT DOUBLE DOWNLOADS
      // =========================
      if (downloadingSubtopicIds.contains(key)) {
        return;
      }

      final connectivityResult = await NetworkService.hasInternet();
      if(!connectivityResult) {
        Get.snackbar('Error', 'Check your internet connection and try again',backgroundColor: Colors.red);
        return;
      }

      downloadingSubtopicIds.add(key);

      // =========================
      // 3️⃣ FETCH FROM API
      // =========================
      final int classNo = loginResponse['classNo'];
      final String academicYear = loginResponse['admissionNo'];
      final String entId = loginResponse['tenantId'];

      final response = await _apiService.loadQuestions(
        subject.name,
        classNo,
        testId,
        academicYear,
        entId,
      );

      if (response == null) {
        throw Exception('API returned null response');
      }

      // =========================
      // 4️⃣ SAVE TO LOCAL STORAGE
      // =========================
      _saveToStorage(questionsStorageKey, response);

      selectedQuestions = response;
      downloadedSubtopicIds.add(key);
      downloadedSubtopicIds.refresh();
    } catch (e) {

      // =========================
      // 5️⃣ TRY FALLBACK CACHE
      // =========================
      final fallback = _readFromStorage(questionsStorageKey);
      isTestCompleted.value = false;
      if (fallback != null) {
        selectedQuestions = fallback;

        // ✅ Add to downloaded set
        if (!downloadedSubtopicIds.contains(key)) {
          downloadedSubtopicIds.add(key);
          downloadedSubtopicIds.refresh();
        }

        // Get.snackbar('Offline Mode', 'Using cached questions');
      } else {
        Get.snackbar('Error', 'Failed to load questions: $e');
        selectedSubtopicId.value = null;
        selectedColumnKey.value = null;
        selectedTestId.value = null;
      }
    } finally {
      downloadingSubtopicIds.remove(key);
      downloadingSubtopicIds.refresh();
    }
  }

  // ============================================================
  // IMPROVED START ASSIGNMENT WITH PROPER STORAGE
  // ============================================================

  void startAssignment() {
    if (selectedSubtopicId.value == null ||
        selectedColumnKey.value == null ||
        selectedTestId.value == null) {
      Get.snackbar('Error', 'Please select an assignment first');
      return;
    }

    try {
      final testDataKey = "test_${selectedTestId.value}";
      // Try to read stored test data
      final stored = _readFromStorage(testDataKey);

      if (stored != null && stored is Map) {

        // Verify it has completion flag
        final isCompleted =  stored['completed'] == true ||
            stored['data']?['completed'] == true;

        if (isCompleted) {
          Session.instance.isNewTest = false;
          Session.instance.isRetest = false;
          Session.instance.storedData = {
            "testId": testDataKey,
            "storedData": stored,
          };

          // Navigate to test analysis
          Get.toNamed(AppRoutes.testAnalysis);
          return;
        }
      }

      // No completed test found - start new assignment
      Session.instance.isNewTest = true;
      Session.instance.storedData = null;

      Get.toNamed(
        AppRoutes.assignmentInstructions,
        arguments: {
          'subtopicId': selectedSubtopicId.value,
          'columnKey': selectedColumnKey.value,
          'testId': selectedTestId.value,
          'selectedQuestion': selectedQuestions
        },
      );

      // Clear selection
      selectedSubtopicId.value = null;
      selectedColumnKey.value = null;
      selectedTestId.value = null;

    } catch (e) {
      print('⚠️ Error in startAssignment: $e');

      // Default to new assignment if anything goes wrong
      Session.instance.isNewTest = true;
      Session.instance.storedData = null;

      Get.toNamed(
        AppRoutes.assignmentInstructions,
        arguments: {
          'subtopicId': selectedSubtopicId.value,
          'columnKey': selectedColumnKey.value,
          'testId': selectedTestId.value,
          'selectedQuestion': selectedQuestions
        },
      );

      selectedSubtopicId.value = null;
      selectedColumnKey.value = null;
      selectedTestId.value = null;
    }
  }

  // ============================================================
  // HELPER METHODS FOR STORAGE
  // ============================================================

  /// Read data from storage with error handling
  dynamic _readFromStorage(String key) {
    try {
      final data = storage.read(key);
      return data;
    } catch (e) {
      print('❌ Error reading from storage [$key]: $e');
      return null;
    }
  }

  /// Save data to storage with error handling
  void _saveToStorage(String key, dynamic value) {
    try {
      storage.save(key, value);
    } catch (e) {
      Get.snackbar('Storage Error', 'Failed to cache data: $e');
    }
  }

  /// Save test results after test completion
  void saveTestResults(String testId, Map<String, dynamic> testData) {
    try {
      final testDataKey = "test_$testId";

      // Ensure completion flag is set
      testData['completed'] = true;
      testData['completedAt'] = DateTime.now().toIso8601String();

      _saveToStorage(testDataKey, testData);
    } catch (e) {
      print('❌ Error saving test results: $e');
    }
  }

  // ============================================================
  // CIRCLE STATE AND STATUS METHODS
  // ============================================================

  bool isSubtopicSelected(String subtopicId, String columnKey, String testId) {
    return selectedSubtopicId.value == subtopicId &&
        selectedColumnKey.value == columnKey &&
        selectedTestId.value == testId;
  }

  /// Get circle state - shows if downloading, downloaded, or default
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
      String status
      ) {
    final key = '$subtopicId-$columnKey-$testId';

    if(status != "ASSIGNED") {
      return AssignmentStatus.locked;
    }

    if (downloadedSubtopicIds.contains(key)) {
      return AssignmentStatus.attempted;
    }

    if (downloadingSubtopicIds.contains(key)) {
      return AssignmentStatus.available;
    }

    return AssignmentStatus.notOpened;
  }

  ScoreLevel? getScoreLevel(
     double? score,
      String status
      ) {

    if (status != "COMPLETED" || score == null) {
      return null;
    }

    // TODO: Implement score level calculation from test results
    if (score <= 2.0) {
      return ScoreLevel.extremelyPoor;
    } else if (score <= 4.0) {
      return ScoreLevel.poor;
    } else if (score <= 6.0) {
      return ScoreLevel.notGood;
    } else if (score <= 8.0) {
      return ScoreLevel.moderate;
    } else {
      return ScoreLevel.satisfactory;
    }
  }

  // ============================================================
  // UTILITY: CLEAR STORAGE (for debugging/testing)
  // ============================================================

  void clearAllCache() {
    try {
      downloadedSubtopicIds.clear();
      downloadingSubtopicIds.clear();
      selectedQuestions = null;
      selectedSubtopicId.value = null;
      selectedColumnKey.value = null;
      selectedTestId.value = null;

      downloadedSubtopicIds.refresh();
      downloadingSubtopicIds.refresh();

      Get.snackbar('Cache', 'All cache cleared');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  String buildQuestionKey(
      String subtopicId,
      String columnKey,
      String testId,
      ) {
    return '$subtopicId-$columnKey-$testId';
  }
}