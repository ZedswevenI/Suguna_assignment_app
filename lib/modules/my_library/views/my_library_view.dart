import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/modules/my_library/controllers/my_library_controller.dart';
import 'package:suguna_teachers_app/modules/my_library/widgets/my_library_content.dart';

class MyLibraryView extends GetView<MyLibraryController> {
  const MyLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Upload reading material'),
      body: const MyLibraryContent(),
    );
  }
}

