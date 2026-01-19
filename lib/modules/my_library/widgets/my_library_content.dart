import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/my_library/controllers/my_library_controller.dart';

class MyLibraryContent extends GetView<MyLibraryController> {
  const MyLibraryContent({super.key});

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
        // Header Information Section
        _buildHeaderInfo(context),
        const SizedBox(height: 32),
        // Title Field
        _buildLabel('Title'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller.titleController,
          hintText: 'Maximum 160 characters',
          maxLength: 160,
          onChanged: controller.updateTitle,
        ),
        const SizedBox(height: 24),
        // Description Field
        _buildLabel('Description'),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller.descriptionController,
          hintText: 'Maximum 500 characters',
          maxLength: 500,
          maxLines: 5,
          onChanged: controller.updateDescription,
        ),
        const SizedBox(height: 24),
        // File Name Field
        _buildLabel('File name'),
        const SizedBox(height: 8),
        _buildFileNameField(context),
        const SizedBox(height: 32),
        // Upload Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    controller.uploadReadingMaterial();
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
                      'Upload',
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Faculty name',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      controller.facultyName.value,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      'Subject',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      controller.subject.value,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLength,
    required void Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        counterText: '',
      ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFileNameField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.fileNameController,
            onChanged: controller.updateFileName,
            decoration: InputDecoration(
              hintText: 'PDF file name (exclude .pdf)',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () async {
            // TODO: Implement file picker when file_picker package is added
            // For now, show a dialog to enter file name manually
            Get.dialog(
              AlertDialog(
                title: const AppText('Select PDF File'),
                content: const AppText(
                  'File picker will be implemented when file_picker package is added.',
                  style: AppTextStyle.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const AppText('OK'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.attach_file,
            color: AppColors.primary,
            size: 24,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[100],
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
