import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/core/widgets/app_app_bar.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/batch_performance_report/controllers/batch_performance_report_controller.dart';

class BatchPerformanceReportView
    extends GetView<BatchPerformanceReportController> {
  const BatchPerformanceReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Batch Performance Report'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (ResponsiveHelper.isTablet(context)) {
            return _buildTabletLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : const Center(
              child: AppText('Batch Performance Report - Mobile Layout'),
            ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: const AppText(
                  'Batch Performance Report - Tablet Layout',
                ),
              ),
            ),
    );
  }
}
