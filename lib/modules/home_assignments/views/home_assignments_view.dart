import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/core/widgets/app_layout.dart';
import 'package:suguna_assignment_app/modules/home_assignments/controllers/home_assignments_controller.dart';

class HomeAssignmentsView extends GetView<HomeAssignmentsController> {
  const HomeAssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      selectedRoute: AppRoutes.home,
      child: LayoutBuilder(
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
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Assignment',
              style: TextStyle(
                fontSize:
                    AppConstants.sectionTitleSize *
                    ResponsiveHelper.getFontSizeMultiplier(context),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context)),
            // Subject List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = controller.subjects[index];
                    return _buildSubjectRow(subject, context);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Assignment',
            style: TextStyle(
              fontSize: AppConstants.sectionTitleSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Subject List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: controller.subjects.length,
                itemBuilder: (context, index) {
                  final subject = controller.subjects[index];
                  return _buildSubjectRow(subject, context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(subject, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.contentPadding,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject.name,
            style: const TextStyle(
              fontSize: AppConstants.normalTextSize,
              color: AppColors.textPrimary,
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.onSubjectTap(subject),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: const RoundedRectangleBorder(),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontSize: AppConstants.normalTextSize),
            ),
          ),
        ],
      ),
    );
  }
}
