import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/routes/app_routes.dart';
import 'package:suguna_teachers_app/core/routes/route_config.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/utils/responsive_helper.dart';
import 'package:suguna_teachers_app/modules/timetable/controllers/timetable_controller.dart';

class TimetableContent extends GetView<TimetableController> {
  const TimetableContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: ResponsiveHelper.getHorizontalPadding(
                context,
              ).copyWith(top: 16, bottom: 16),
              child: ResponsiveHelper.isTablet(context)
                  ? Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: _buildContent(context),
                      ),
                    )
                  : _buildContent(context),
            ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final now = DateTime.now();
    final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Block
        _buildDateBlock(
          dayNames[now.weekday - 1],
          now.day.toString(),
          monthNames[now.month - 1],
        ),
        const SizedBox(height: 20),
        // Information Card
        _buildInfoCard(context),
        const SizedBox(height: 20),
        // Action Buttons
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildDateBlock(String day, String date, String month) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            month,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Batch code', ''),
            const SizedBox(height: 16),
            _buildInfoRow('Timing', '00:00-00:00'),
            const SizedBox(height: 16),
            _buildInfoRow('Venue', ''),
            const SizedBox(height: 16),
            _buildInfoRow('OTP', 'NA'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            // Description
            Text(
              'Description',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'MVLL1/Time table is not uploaded, Please use fiitjeelogin.com OR contact your center AO',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement review functionality
              Get.snackbar(
                'Review',
                'Review functionality coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Review',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              RouteConfig.router.go(AppRoutes.attendance);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Attendance',
              style: const TextStyle(
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
}
