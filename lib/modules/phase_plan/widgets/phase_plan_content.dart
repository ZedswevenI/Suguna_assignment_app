import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/modules/phase_plan/controllers/phase_plan_controller.dart';

class PhasePlanContent extends GetView<PhasePlanController> {
  const PhasePlanContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Faculty and Batch Information Section (Grey)
                _buildInfoSection(context),
                // Table Header (Blue)
                _buildTableHeader(context),
                // Phase Plan Table (White Scrollable)
                Expanded(child: _buildPhasePlanTable(context)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Faculty name', controller.facultyName.value, context),
        const SizedBox(height: 12),
        _buildInfoRow('Batch code', controller.batchCode.value, context),
        const SizedBox(height: 12),
        _buildInfoRow('Subject', controller.subject.value, context),
        const SizedBox(height: 12),
        _buildInfoRow('Class', controller.className.value, context),
        const SizedBox(height: 12),
        _buildInfoRow('Program code', controller.programCode.value, context),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ResponsiveHelper.isTablet(context) ? 140 : 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
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
    return Row(
      children: [
        SizedBox(width: isTablet ? 60 : 45, child: _buildHeaderText('Phase')),
        SizedBox(width: isTablet ? 60 : 45, child: _buildHeaderText('Seq')),
        Expanded(flex: 3, child: _buildHeaderText('Chapter')),
        SizedBox(width: isTablet ? 90 : 70, child: _buildHeaderText('CC')),
        SizedBox(width: isTablet ? 60 : 50, child: _buildHeaderText('Hrs')),
        SizedBox(width: isTablet ? 70 : 60, child: _buildHeaderText('MP T')),
      ],
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),
    );
  }

  Widget _buildPhasePlanTable(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.phasePlanItems.length,
        itemBuilder: (context, index) {
          final item = controller.phasePlanItems[index];
          final isLastInPhase =
              index == controller.phasePlanItems.length - 1 ||
              controller.phasePlanItems[index + 1].phase != item.phase;

          return Container(
            color: AppColors.backgroundLight,
            padding: EdgeInsets.only(
              left: ResponsiveHelper.getHorizontalPadding(context).horizontal,
              right: ResponsiveHelper.getHorizontalPadding(context).horizontal,
            ),
            child: ResponsiveHelper.isTablet(context)
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: _buildTableRow(context, item, isLastInPhase),
                    ),
                  )
                : _buildTableRow(context, item, isLastInPhase),
          );
        },
      ),
    );
  }

  Widget _buildTableRow(
    BuildContext context,
    PhasePlanItem item,
    bool isLastInPhase,
  ) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final fontSize = isTablet ? 14.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 12 : 10,
      ),
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
            width: isTablet ? 60 : 45,
            child: Text(
              item.phase.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? 60 : 45,
            child: Text(
              item.seq.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.chapter,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              maxLines: isTablet ? null : 2,
              overflow: isTablet ? null : TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: isTablet ? 90 : 70,
            child: Text(
              item.courseCode,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: isTablet ? 60 : 50,
            child: Text(
              item.hours.toString(),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: isTablet ? 70 : 60,
            child: Checkbox(
              value: item.isCompleted,
              onChanged: (value) {
                controller.toggleCompletion(item);
              },
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
