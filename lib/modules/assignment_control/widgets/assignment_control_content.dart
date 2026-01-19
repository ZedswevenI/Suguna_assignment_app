import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/assignment_control/controllers/assignment_control_controller.dart';

class AssignmentControlContent extends GetView<AssignmentControlController> {
  const AssignmentControlContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Information Section (Grey)
                _buildInfoSection(context),
                // Table Header (Blue)
                _buildTableHeader(context),
                // Assignment Table (Scrollable)
                Expanded(child: _buildAssignmentTable(context)),
              ],
            ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
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
                child: _buildInfoContent(context),
              ),
            )
          : _buildInfoContent(context),
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoColumn('Subject', controller.subject.value, context),
        ),
        Expanded(
          child: _buildInfoColumn('Class', controller.className.value, context),
        ),
        Expanded(
          child: _buildInfoColumn(
            'Batch code',
            controller.batchCode.value,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          style: AppTextStyle.bodySmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 4),
        AppText(
          value,
          style: AppTextStyle.bodyMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
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
    final headerFontSize = isTablet ? 14.0 : 12.0;

    return Row(
      children: [
        SizedBox(
          width: isTablet ? 70 : 60,
          child: AppText(
            'Phase',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            fontSize: headerFontSize,
            color: AppColors.textWhite,
          ),
        ),
        Expanded(
          flex: 2,
          child: AppText(
            'Chapter',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            fontSize: headerFontSize,
            color: AppColors.textWhite,
          ),
        ),
        Expanded(
          flex: 3,
          child: AppText(
            'Topic Group',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            fontSize: headerFontSize,
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(
          width: isTablet ? 80 : 70,
          child: AppText(
            'Status',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
            fontSize: headerFontSize,
            color: AppColors.textWhite,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentTable(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.assignmentItems.length,
        itemBuilder: (context, index) {
          final item = controller.assignmentItems[index];
          final isLastInPhase =
              index == controller.assignmentItems.length - 1 ||
              controller.assignmentItems[index + 1].phase != item.phase;
          final isEven = index % 2 == 0;

          return Container(
            color: isEven ? AppColors.backgroundLight : Colors.grey[100],
            child: ResponsiveHelper.isTablet(context)
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: ResponsiveHelper.getHorizontalPadding(context),
                        child: _buildTableRow(context, item, isLastInPhase),
                      ),
                    ),
                  )
                : Padding(
                    padding: ResponsiveHelper.getHorizontalPadding(context),
                    child: _buildTableRow(context, item, isLastInPhase),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    AssignmentItem item,
    bool isLastInPhase,
  ) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final fontSize = isTablet ? 14.0 : 12.0;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: isLastInPhase ? 2 : 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isTablet ? 70 : 60,
            child: AppText(
              item.phase.toString(),
              style: AppTextStyle.bodyMedium,
              fontSize: fontSize,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppText(
              item.chapter,
              style: AppTextStyle.bodyMedium,
              fontSize: fontSize,
              color: AppColors.textPrimary,
              maxLines: isTablet ? null : 2,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              item.topicGroup,
              style: AppTextStyle.bodyMedium,
              fontSize: fontSize,
              color: AppColors.textPrimary,
              maxLines: isTablet ? null : 2,
            ),
          ),
          SizedBox(
            width: isTablet ? 80 : 70,
            child: Center(
              child: Checkbox(
                value: item.isCompleted,
                onChanged: (value) {
                  controller.toggleCompletion(item);
                },
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
