class TopicModel {
  final String id;
  final String name;
  final List<SubtopicModel> subtopics;

  TopicModel({
    required this.id,
    required this.name,
    required this.subtopics,
  });
}

// class SubtopicModel {
//   final String id;
//   final String name;
//   final Map<String, List<AssignmentScore>> scores;
//
//   SubtopicModel({
//     required this.id,
//     required this.name,
//     required this.scores,
//   });
// }


class SubtopicModel {
  final String id;
  final String name;

  /// Category -> SubCategory -> Assignments
  final Map<String, Map<String, List<AssignmentScore>>> scores;

  SubtopicModel({
    required this.id,
    required this.name,
    required this.scores,
  });
}

// class AssignmentScore {
//   final double score;
//   final bool isDownloaded;
//   final bool isDownloading;
//
//   AssignmentScore({
//     required this.score,
//     this.isDownloaded = false,
//     this.isDownloading = false,
//   });
// }

class AssignmentScore {
  final String testId,status;
  final double? cgpa;
  final int sortOrder;
  final bool isEnabled;
  AssignmentScore({
    required this.testId,
    required this.sortOrder,
    required this.status,
    required this.isEnabled,
    this.cgpa
  });
}
