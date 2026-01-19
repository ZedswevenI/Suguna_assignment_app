import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_teachers_app/core/routes/app_routes.dart';
import 'package:suguna_teachers_app/core/theme/app_colors.dart';
import 'package:suguna_teachers_app/core/widgets/app_text.dart';
import 'package:suguna_teachers_app/modules/home/controllers/home_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.primary),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person,
                    size: 64,
                    color: AppColors.textWhite,
                  ),
                  const SizedBox(height: 8),
                  AppText.headlineMedium(
                    'Teacher App',
                    color: AppColors.textWhite,
                  ),
                ],
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.schedule,
                  title: 'Timetable',
                  route: AppRoutes.timetable,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.groups,
                  title: 'Batch Control',
                  route: AppRoutes.batchControl,
                ),
                const Divider(),
                _buildLogoutMenuItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final homeController = Get.find<HomeController>();

    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: AppText.bodyLarge(title),
      onTap: () {
        Navigator.pop(context); // Close drawer

        // Change view in home controller instead of navigating
        if (route == AppRoutes.timetable) {
          homeController.showTimetable();
        } else if (route == AppRoutes.batchControl) {
          homeController.showBatchControl();
        } else if (route == AppRoutes.home) {
          homeController.showTimetable(); // Default to timetable
        }
      },
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: AppColors.error),
      title: AppText.bodyLarge('Logout', color: AppColors.error),
      onTap: () {
        Navigator.pop(context); // Close drawer
        _showLogoutDialog(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final homeController = Get.find<HomeController>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: AppText.titleLarge('Logout'),
          content: AppText.bodyMedium('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: AppText.bodyMedium('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                homeController.logout();
              },
              child: AppText.bodyMedium('Logout', color: AppColors.error),
            ),
          ],
        );
      },
    );
  }
}
