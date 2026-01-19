import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/assignment_control/controllers/assignment_control_controller.dart';
import 'package:suguna_teachers_app/modules/assignment_control/widgets/assignment_control_content.dart';

class AssignmentControlView extends GetView<AssignmentControlController> {
  const AssignmentControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Assignment Control'),
      body: const AssignmentControlContent(),
    );
  }
}

