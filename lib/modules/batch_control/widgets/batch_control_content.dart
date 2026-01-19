import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/batch_control/controllers/batch_control_controller.dart';

class BatchControlContent extends GetView<BatchControlController> {
  const BatchControlContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: ResponsiveHelper.getHorizontalPadding(
                context,
              ).copyWith(top: 24, bottom: 24),
              child: ResponsiveHelper.isTablet(context)
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: _buildForm(context),
                      ),
                    )
                  : _buildForm(context),
            ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Action Dropdown
        _buildLabel('Select action'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: controller.selectedAction.value,
          items: controller.actionOptions.map((action) {
            return DropdownMenuItem<String>(
              value: action,
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: controller.selectAction,
          hint: 'Select action',
        ),
        const SizedBox(height: 24),

        // Select Batch Code Dropdown
        _buildLabel('Select batch code'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: controller.selectedBatchCode.value,
          items: controller.batchCodeOptions.map((batchCode) {
            return DropdownMenuItem<String>(
              value: batchCode,
              child: Text(
                batchCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: controller.selectBatchCode,
          hint: 'Select batch code',
        ),
        const SizedBox(height: 24),

        // Select Subject Dropdown
        _buildLabel('Select Subject'),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: controller.selectedSubject.value,
          items: controller.subjectOptions.map((subject) {
            return DropdownMenuItem<String>(
              value: subject,
              child: Text(
                subject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: controller.selectSubject,
          hint: 'Select Subject',
        ),
        const SizedBox(height: 40),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final validationError = controller.validateForm();
              if (validationError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(validationError),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              controller.submit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return AppText(
      text,
      style: AppTextStyle.bodyLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value != null ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
