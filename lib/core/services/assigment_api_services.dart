import '../../data/models/subject_model.dart';
import 'api_service.dart';

/// API Service for Circulars Module
class AssignmentApiServices extends ApiService {
  /// Get all circulars
  Future<List<SubjectModel>> getAssignments(String endId,String regNo) async {
    try {
      final response = await post(
        '/student/get/assnsubjects',
        body: {
          "entiId":endId,
          "regNo": regNo
        },
      );
      final List subjectsJson = response['data']['subjects'];
      final List<SubjectModel> subjects = subjectsJson
          .map((e) => SubjectModel.fromJson(e))
          .toList();
      return subjects;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAssignmentTopics(String subjectName,int classNo) async {
    try {
      final response = await post(
        '/student/get/assignments',
        body: {
          "entiId":"69005a54-19bc-40c1-bff2-646e4d40563b",
          "regNo":"9051642680002",
          "subjectId" : subjectName,
          "classNo" : classNo
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> loadQuestions(String subjectName,int classNo,String testId) async {
    try {
      final response = await post(
        '/student/download/assignments',
        body: {
          "entiId": "69005a54-19bc-40c1-bff2-646e4d40563b",
          "regNo": "9051642680002",
          "testId": testId,
          "subjectId": subjectName,
          "classNo":classNo
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }



  /// Mark circular as read
  Future<Map<String, dynamic>> login(String endId) async {
    try {
      final response = await post('/student/login',body: {
        "regNo":endId
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get circular read status
  Future<Map<String, dynamic>> getReadStatus(String circularId) async {
    try {
      final response = await get('/circulars/$circularId/read-status');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
