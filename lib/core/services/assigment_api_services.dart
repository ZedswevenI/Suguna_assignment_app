import '../../data/models/subject_model.dart';
import 'api_service.dart';

/// API Service for Circulars Module
class AssignmentApiServices extends ApiService {
  /// Get all circulars
  Future<dynamic> getAssignments(String endId,String regNo) async {
    try {
      final response = await post(
        '/student/get/assnsubjects',
        body: {
          "entiId":endId,
          "regNo": regNo
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getAssignmentTopics(String subjectName,int classNo,String regNo,String entId) async {
    try {
      final response = await post(
        '/student/get/assignments',
        body: {
          "entiId":entId,
          "regNo":regNo,
          "subjectId" : subjectName,
          "classNo" : classNo
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> loadQuestions(String subjectName,int classNo,String testId,String regNo,String entId) async {
    try {
      final response = await post(
        '/student/download/assignments',
        body: {
          "entiId":entId,
          "regNo": regNo,
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

  Future<dynamic> getAnswers(String batchId,String testId,String regNo,String entId) async {
    try {
      final response = await post(
        '/assignment/result/list/student?testId=$testId',
        body: {
          "entiId":entId,
          "admissionNo": regNo,
          "batchId": batchId,
          'testId': testId
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
  Future<dynamic> submitResult(dynamic body) async {
    try {
      final response = await post(
        '/assignment/result/submit',
        body: body,
      );
      return response;
    } catch (e) {
      return e;
    }
  }
}
