import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/core/widgets/app_drawer.dart';
import 'package:suguna_teachers_app/modules/home/controllers/home_controller.dart';
import 'package:suguna_teachers_app/modules/timetable/widgets/timetable_content.dart';
import 'package:suguna_teachers_app/modules/batch_control/widgets/batch_control_content.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppAppBar(
          title: controller.currentView.value == HomeViewType.timetable
              ? 'Timetable'
              : 'Batch Control',
          showBackButton: false,
        ),
        drawer: const AppDrawer(),
        body: controller.currentView.value == HomeViewType.timetable
            ? const TimetableContent()
            : const BatchControlContent(),
      ),
    );
  }
}
