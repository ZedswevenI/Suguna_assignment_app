import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/attendance/controllers/attendance_controller.dart';

class AttendanceContent extends GetView<AttendanceController> {
  const AttendanceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Information Section (Grey)
                _buildInfoSection(context),
                // Search Section
                _buildSearchSection(context),
                // Check All Section
                _buildCheckAllSection(context),
                // Students List (Scrollable)
                Expanded(child: _buildStudentsList(context)),
                // Submit Button
                _buildSubmitButton(context),
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
          child: _buildInfoColumn('Class', controller.className.value, context),
        ),
        Expanded(
          child: _buildInfoColumn(
            'Batch code',
            controller.batchCode.value,
            context,
          ),
        ),
        Expanded(
          child: _buildInfoColumn(
            'Date',
            _formatDate(controller.date.value),
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

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.backgroundLight,
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 12, bottom: 12),
      child: ResponsiveHelper.isTablet(context)
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildSearchField(context),
              ),
            )
          : _buildSearchField(context),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        controller.updateSearchQuery(value);
      },
      decoration: InputDecoration(
        hintText: 'Search by name or enrolment number...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: Obx(
          () => controller.searchQuery.value.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    controller.updateSearchQuery('');
                  },
                ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildCheckAllSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary.withValues(alpha: 0.1),
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 12, bottom: 12),
      child: ResponsiveHelper.isTablet(context)
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildCheckAllContent(context),
              ),
            )
          : _buildCheckAllContent(context),
    );
  }

  Widget _buildCheckAllContent(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: controller.isAllChecked.value,
          onChanged: (value) {
            controller.toggleAllAttendance();
          },
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(
            'Check All',
            style: AppTextStyle.bodyLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Obx(() {
          final filteredCount = controller.filteredStudentItems.length;
          final filteredPresentCount = controller.filteredStudentItems
              .where((item) => item.isPresent)
              .length;
          final totalCount = controller.totalCount;

          return AppText(
            controller.searchQuery.value.isEmpty
                ? 'Present: $filteredPresentCount/$totalCount'
                : 'Present: $filteredPresentCount/$filteredCount (Total: $totalCount)',
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          );
        }),
      ],
    );
  }

  Widget _buildStudentsList(BuildContext context) {
    return Obx(() {
      final filteredItems = controller.filteredStudentItems;
      if (filteredItems.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppText(
              controller.searchQuery.value.isEmpty
                  ? 'No students found'
                  : 'No students match your search',
              style: AppTextStyle.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          final originalIndex = controller.studentAttendanceItems.indexOf(item);
          final isEven = index % 2 == 0;

          return Container(
            color: isEven ? AppColors.backgroundLight : Colors.grey[100],
            child: ResponsiveHelper.isTablet(context)
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Padding(
                        padding: ResponsiveHelper.getHorizontalPadding(context),
                        child: _buildStudentRow(context, item, originalIndex),
                      ),
                    ),
                  )
                : Padding(
                    padding: ResponsiveHelper.getHorizontalPadding(context),
                    child: _buildStudentRow(context, item, originalIndex),
                  ),
          );
        },
      );
    });
  }

  Widget _buildStudentRow(
    BuildContext context,
    StudentAttendanceItem item,
    int index,
  ) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final fontSize = isTablet ? 14.0 : 13.0;
    final padding = isTablet
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isPresent,
            onChanged: (value) {
              controller.toggleStudentAttendance(index);
            },
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.enrolmentNumber,
                  style: AppTextStyle.bodyMedium,
                  fontSize: fontSize - 1,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                const SizedBox(height: 4),
                AppText(
                  item.studentName.toUpperCase(),
                  style: AppTextStyle.bodyMedium,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: isTablet ? 2 : 1,
                ),
              ],
            ),
          ),
          Icon(
            item.isPresent ? Icons.check_circle : Icons.cancel,
            color: item.isPresent ? Colors.green : Colors.grey[400],
            size: isTablet ? 24 : 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getHorizontalPadding(
        context,
      ).copyWith(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ResponsiveHelper.isTablet(context)
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildSubmitButtonContent(context),
              ),
            )
          : _buildSubmitButtonContent(context),
    );
  }

  Widget _buildSubmitButtonContent(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                controller.submitAttendance();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Obx(
          () => controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textWhite,
                    ),
                  ),
                )
              : const AppText(
                  'Submit Attendance',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textWhite,
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
