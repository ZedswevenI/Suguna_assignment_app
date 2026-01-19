import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/controllers/student_performance_report_controller.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/widgets/student_performance_report_content.dart';

class StudentPerformanceReportView
    extends GetView<StudentPerformanceReportController> {
  const StudentPerformanceReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Student Performance Report'),
      body: const StudentPerformanceReportContent(),
    );
  }
}
