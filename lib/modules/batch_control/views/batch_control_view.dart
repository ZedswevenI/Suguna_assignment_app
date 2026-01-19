import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/batch_control/controllers/batch_control_controller.dart';
import 'package:suguna_teachers_app/modules/batch_control/widgets/batch_control_content.dart';

class BatchControlView extends GetView<BatchControlController> {
  const BatchControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Batch Control'),
      body: const BatchControlContent(),
    );
  }
}
