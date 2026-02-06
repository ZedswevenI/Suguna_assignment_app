class SubjectModel {
  final String id;
  final String name;
  final String classInfo;

  SubjectModel({
    required this.id,
    required this.name,
    required this.classInfo,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['subjectId'],
      name: json['subjectName'],
      classInfo: 'Class ${json['classNo']}',
    );
  }
}