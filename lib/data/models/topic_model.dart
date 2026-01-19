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

class SubtopicModel {
  final String id;
  final String name;
  final Map<String, AssignmentScore> scores; // Key: "Board", "JEE Main", "JEE Advanced"

  SubtopicModel({
    required this.id,
    required this.name,
    required this.scores,
  });
}

class AssignmentScore {
  final double score;
  final bool isDownloaded;
  final bool isDownloading;

  AssignmentScore({
    required this.score,
    this.isDownloaded = false,
    this.isDownloading = false,
  });
}
