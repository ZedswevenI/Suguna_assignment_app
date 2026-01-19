import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/controllers/student_performance_report_controller.dart';

class StudentPerformanceReportContent
    extends GetView<StudentPerformanceReportController> {
  const StudentPerformanceReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Report Header (Light Grey Background)
                _buildReportHeader(context),
                // Table Header (Blue Background)
                _buildTableHeader(context),
                // Student Performance Table (Scrollable)
                Expanded(child: _buildStudentTable(context)),
              ],
            ),
    );
  }

  Widget _buildReportHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 16, bottom: 16),
      child: ResponsiveHelper.isTablet(context)
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildHeaderContent(context),
              ),
            )
          : _buildHeaderContent(context),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Batch code',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.batchCode.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.subject.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.info,
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 12, bottom: 12),
      child: ResponsiveHelper.isTablet(context)
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildHeaderRow(context),
              ),
            )
          : _buildHeaderRow(context),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final iconSize = isTablet ? 20.0 : 18.0;
    final headerFontSize = isTablet ? 12.0 : 11.0;
    final subHeaderFontSize = isTablet ? 11.0 : 10.0;
    final cgpaWidth = isTablet ? 140.0 : 110.0;

    return Row(
      children: [
        // Icon + Enrolment number and Student name (stacked)
        SizedBox(
          width: isTablet ? 40 : 32,
          child: Icon(
            Icons.bar_chart,
            color: AppColors.textWhite,
            size: iconSize,
          ),
        ),
        SizedBox(width: isTablet ? 8 : 6),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enrolment number',
                style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Student name',
                style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textWhite,
                ),
              ),
            ],
          ),
        ),
        // CGPA with sub-headers
        SizedBox(
          width: cgpaWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'CGPA',
                style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      'Asgn',
                      style: TextStyle(
                        fontSize: subHeaderFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Test',
                      style: TextStyle(
                        fontSize: subHeaderFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Net',
                      style: TextStyle(
                        fontSize: subHeaderFontSize,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTable(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.studentPerformanceItems.length,
        itemBuilder: (context, index) {
          final item = controller.studentPerformanceItems[index];
          final isEven = index % 2 == 0;

          return Container(
            color: isEven ? AppColors.backgroundLight : Colors.grey[100],
            child: ResponsiveHelper.isTablet(context)
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: ResponsiveHelper.getHorizontalPadding(context),
                        child: _buildStudentRow(context, item),
                      ),
                    ),
                  )
                : Padding(
                    padding: ResponsiveHelper.getHorizontalPadding(context),
                    child: _buildStudentRow(context, item),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildStudentRow(BuildContext context, StudentPerformanceItem item) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final iconSize = isTablet ? 20.0 : 18.0;
    final fontSize = isTablet ? 13.0 : 12.0;
    final scoreFontSize = isTablet ? 12.0 : 11.0;
    final cgpaWidth = isTablet ? 140.0 : 110.0;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          SizedBox(
            width: isTablet ? 40 : 32,
            child: Icon(
              Icons.bar_chart,
              color: AppColors.textSecondary,
              size: iconSize,
            ),
          ),
          SizedBox(width: isTablet ? 8 : 6),
          // Enrolment number and Student name
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.enrolmentNumber,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: isTablet ? 4 : 3),
                Text(
                  item.studentName.toUpperCase(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: isTablet ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // CGPA scores
          SizedBox(
            width: cgpaWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CGPA (can be empty)
                SizedBox(height: isTablet ? 4 : 2),
                Text(
                  item.cgpa ?? '',
                  style: TextStyle(
                    fontSize: scoreFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isTablet ? 8 : 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Asgn
                    Flexible(
                      child: Text(
                        item.asgnScore.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: scoreFontSize,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Test
                    Flexible(
                      child: Text(
                        item.testScore.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: scoreFontSize,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Net (with color coding)
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 8 : 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.isHighNetScore
                              ? Colors.orange[300]
                              : Colors.pink[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.netScore.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
