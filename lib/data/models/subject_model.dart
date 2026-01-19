class SubjectModel {
  final String id;
  final String name;
  final String? classInfo;

  SubjectModel({
    required this.id,
    required this.name,
    this.classInfo,
  });
}
