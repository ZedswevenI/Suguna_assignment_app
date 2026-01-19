import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/core/widgets/app_layout.dart';

class UsageView extends GetView {
  const UsageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      selectedRoute: AppRoutes.usage,
      showBackButton: true,
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
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: Container(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usage Legend',
                style: TextStyle(
                  fontSize: AppConstants.sectionTitleSize *
                      ResponsiveHelper.getFontSizeMultiplier(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSpacing(context)),
              _buildLegendItem(context, AppColors.scoreRed, '0.0 - 2.0'),
              _buildLegendItem(context, AppColors.scoreOrange, '2.1 - 4.0'),
              _buildLegendItem(context, AppColors.scoreYellow, '4.1 - 7.0'),
              _buildLegendItem(
                  context, AppColors.scoreLightGreen, '7.1 - 8.0'),
              _buildLegendItem(
                  context, AppColors.scoreDarkGreen, '8.1 - 10.0'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppConstants.contentPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Legend',
              style: TextStyle(
                fontSize: AppConstants.sectionTitleSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildLegendItem(context, AppColors.scoreRed, '0.0 - 2.0'),
            _buildLegendItem(context, AppColors.scoreOrange, '2.1 - 4.0'),
            _buildLegendItem(context, AppColors.scoreYellow, '4.1 - 7.0'),
            _buildLegendItem(context, AppColors.scoreLightGreen, '7.1 - 8.0'),
            _buildLegendItem(context, AppColors.scoreDarkGreen, '8.1 - 10.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: AppConstants.circleSize,
            height: AppConstants.circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: AppColors.border, width: 1),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            meaning,
            style: const TextStyle(
              fontSize: AppConstants.normalTextSize,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
