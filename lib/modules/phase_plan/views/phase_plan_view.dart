import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/phase_plan/controllers/phase_plan_controller.dart';
import 'package:suguna_teachers_app/modules/phase_plan/widgets/phase_plan_content.dart';

class PhasePlanView extends GetView<PhasePlanController> {
  const PhasePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Phase plan'),
      body: const PhasePlanContent(),
    );
  }
}
