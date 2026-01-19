import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/timetable/controllers/timetable_controller.dart';
import 'package:suguna_teachers_app/modules/timetable/widgets/timetable_content.dart';

class TimetableView extends GetView<TimetableController> {
  const TimetableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Timetable'),
      body: const TimetableContent(),
    );
  }
}
