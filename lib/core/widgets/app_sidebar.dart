import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';

class AppSidebar extends StatelessWidget {
  final String selectedRoute;

  const AppSidebar({
    super.key,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.sidebarWidth,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            title: 'Home',
            route: AppRoutes.home,
            icon: Icons.home,
          ),
          _buildMenuItem(
            context,
            title: 'Usage',
            route: AppRoutes.usage,
            icon: Icons.info_outline,
          ),
          _buildMenuItem(
            context,
            title: 'File Manager',
            route: AppRoutes.fileManager,
            icon: Icons.folder_outlined,
          ),
          _buildMenuItem(
            context,
            title: 'Discussion',
            route: AppRoutes.discussion,
            icon: Icons.chat_bubble_outline,
          ),
          _buildMenuItem(
            context,
            title: 'Reset',
            route: AppRoutes.reset,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String route,
    IconData? icon,
  }) {
    final isSelected = selectedRoute == route;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        if (!isSelected) {
          Get.toNamed(route);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.contentPadding,
          vertical: 12,
        ),
        color: isSelected ? AppColors.sidebarSelected : Colors.transparent,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.normalTextSize,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
