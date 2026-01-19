import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/attendance/controllers/attendance_controller.dart';
import 'package:suguna_teachers_app/modules/attendance/widgets/attendance_content.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Attendance'),
      body: const AttendanceContent(),
    );
  }
}
