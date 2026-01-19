import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/modules/assignment_instructions/controllers/assignment_instructions_controller.dart';

class AssignmentInstructionsView
    extends GetView<AssignmentInstructionsController> {
  const AssignmentInstructionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
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
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
          maxHeight: 600,
        ),
        child: Container(
          color: Colors.white,
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: Text(
                      'eCM – ASSIGNMENT',
                      style: TextStyle(
                        fontSize: AppConstants.sectionTitleSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Instructions
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => Text(
                      controller.instructions.value,
                      style: const TextStyle(
                        fontSize: AppConstants.normalTextSize,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: controller.onDecline,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Decline'),
                  ),
                  ElevatedButton(
                    onPressed: controller.onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 500),
        color: Colors.white,
        padding: const EdgeInsets.all(AppConstants.contentPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const Expanded(
                  child: Text(
                    'eCM – ASSIGNMENT',
                    style: TextStyle(
                      fontSize: AppConstants.sectionTitleSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Instructions
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () => Text(
                    controller.instructions.value,
                    style: const TextStyle(
                      fontSize: AppConstants.normalTextSize,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.onDecline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.textWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  onPressed: controller.onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
