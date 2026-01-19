import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/core/widgets/app_layout.dart';

class DiscussionListView extends GetView {
  const DiscussionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      selectedRoute: AppRoutes.discussion,
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
        child: Text(
          'Discussion List',
          style: TextStyle(
            fontSize: AppConstants.sectionTitleSize *
                ResponsiveHelper.getFontSizeMultiplier(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return const Center(
      child: Text(
        'Discussion List',
        style: TextStyle(fontSize: AppConstants.sectionTitleSize),
      ),
    );
  }
}
