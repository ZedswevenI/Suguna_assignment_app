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
    return Scaffold(
      // selectedRoute: AppRoutes.home,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (ResponsiveHelper.isTablet(context)) {
              return _buildTabletLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F8), // 🌫 Soft background
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assignments",style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w600),),
                _buildContextCard(),
                _buildTabsCard(),
                Expanded(child: _buildAssignmentsGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTabletHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Academic Year Dropdown
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedAcademicYear.value,
              items: controller.academicYears
                  .map(
                    (year) => DropdownMenuItem(
                  value: year,
                  child: Text(year),
                ),
              )
                  .toList(),
              onChanged: controller.onAcademicYearChanged,
            ),
          ),

          const Spacer(),

          // Current Class
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              return Text(
                'Class ${controller.currentClass.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: _surfaceDecoration(),
      child: Row(
        children: [
          const Text(
            'Academic Year',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),

          DropdownButtonHideUnderline(
            child: Obx(() {
              return DropdownButton<String>(
                value: controller.selectedAcademicYear.value,
                items: controller.academicYears
                    .map(
                      (y) => DropdownMenuItem(
                    value: y,
                    child: Text(y),
                  ),
                )
                    .toList(),
                onChanged: controller.onAcademicYearChanged,
              );
            }),
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              return Text(
                'Class ${controller.currentClass.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsCard() {
    return Container();
    // return Container(
    //   decoration: _surfaceDecoration(),
    //   child: TabBar(
    //     controller: controller.tabController,
    //     indicatorColor: AppColors.primary,
    //     labelColor: AppColors.primary,
    //     unselectedLabelColor: AppColors.textSecondary,
    //     labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    //     tabs: const [
    //       Tab(text: 'Assignments'),
    //       Tab(text: 'Completed'),
    //       Tab(text: 'Overdue'),
    //     ],
    //   ),
    // );
  }

  Widget _buildAssignmentsGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFF2F5), // 🌫 subtle grid background
          borderRadius: BorderRadius.circular(14),
        ),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: controller.subjects.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            return _buildSubjectCard(controller.subjects[index]);
          },
        ),
      );
    });
  }

  Widget _buildSubjectCard(subject) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7EEFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Subject Name
          Expanded(
            child: Text(
              subject.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Continue Button
          TextButton(
            onPressed: () => controller.onSubjectTap(subject),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }



  BoxDecoration _surfaceDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
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
