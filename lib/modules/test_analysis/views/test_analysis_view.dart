import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/modules/test_analysis/controllers/test_analysis_controller.dart';

class TestAnalysisView extends GetView<TestAnalysisController> {
  const TestAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Test Analysis',
          style: TextStyle(color: AppColors.textWhite),
        ),
        elevation: 0,
      ),
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

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        // Top Summary Bar
        Container(
          padding: ResponsiveHelper.getPadding(context),
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(context, 'Total Questions', '30'),
                _buildSummaryItem(context, 'Answered', '25'),
                _buildSummaryItem(context, 'Marked', '3'),
                _buildSummaryItem(context, 'Not Visited', '2'),
                _buildSummaryItem(context, 'Total Marks', '120'),
              ],
            ),
          ),
        ),
        // Table
        Expanded(
          child: SingleChildScrollView(
            child: _buildTable(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Top Summary Bar
        Container(
          padding: const EdgeInsets.all(AppConstants.contentPadding),
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(context, 'Total Questions', '30'),
              _buildSummaryItem(context, 'Answered', '25'),
              _buildSummaryItem(context, 'Marked', '3'),
              _buildSummaryItem(context, 'Not Visited', '2'),
              _buildSummaryItem(context, 'Total Marks', '120'),
            ],
          ),
        ),
        // Table
        Expanded(
          child: SingleChildScrollView(
            child: _buildTable(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.sectionTitleSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.smallLabelSize,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getMaxContentWidth(context),
      ),
      child: Container(
        padding: ResponsiveHelper.getPadding(context),
        child: Column(
          children: [
            // Header
            _buildTableRow(
              ['Question No', 'Type', 'Your Answer', 'Marks', 'View'],
              isHeader: true,
            ),
            // Data Rows
            ...List.generate(30, (index) {
              return _buildTableRow([
                '${index + 1}',
                'MCQ',
                'A',
                '4',
                'View',
              ]);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.contentPadding,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isHeader ? AppColors.backgroundLight : Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: cells.asMap().entries.map((entry) {
          final index = entry.key;
          final cell = entry.value;
          final isViewColumn = index == cells.length - 1;

          return Expanded(
            child: isViewColumn
                ? TextButton(
                    onPressed: () => controller.viewQuestion(int.parse(cells[0])),
                    child: Text(
                      cell,
                      style: TextStyle(
                        fontSize: AppConstants.normalTextSize,
                        color: AppColors.primary,
                        fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  )
                : Text(
                    cell,
                    style: TextStyle(
                      fontSize: AppConstants.normalTextSize,
                      color: isHeader
                          ? AppColors.textPrimary
                          : AppColors.textPrimary,
                      fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
