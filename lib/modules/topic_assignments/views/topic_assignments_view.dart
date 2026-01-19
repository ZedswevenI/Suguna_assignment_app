import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/core/widgets/app_layout.dart';
import 'package:suguna_assignment_app/core/widgets/score_circle.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/modules/topic_assignments/controllers/topic_assignments_controller.dart';

class TopicAssignmentsView extends GetView<TopicAssignmentsController> {
  const TopicAssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final subject = Get.arguments as SubjectModel;

    return AppLayout(
      selectedRoute: AppRoutes.topicAssignments,
      subjectName: subject.name,
      classInfo: subject.classInfo,
      assignmentLabel: 'Assignment',
      showSidebar: false,
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
    return Padding(
      padding: ResponsiveHelper.getPadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: Row(
          children: [
            // Left Panel - Topics
            _buildTopicList(context),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            // Right Panel - Grid
            Expanded(child: _buildGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.contentPadding),
      child: Row(
        children: [
          // Left Panel - Topics
          _buildTopicList(context),
          const SizedBox(width: 16),
          // Right Panel - Grid
          Expanded(child: _buildGrid(context)),
        ],
      ),
    );
  }

  Widget _buildTopicList(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Obx(() {
        return ListView.builder(
          itemCount: controller.topics.length,
          itemBuilder: (context, index) {
            final topic = controller.topics[index];
            final isSelected = controller.selectedTopicId.value == topic.id;
            return InkWell(
              onTap: () => controller.selectTopic(topic.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: isSelected
                    ? AppColors.sidebarSelected
                    : Colors.transparent,
                child: Text(
                  topic.name,
                  style: TextStyle(
                    fontSize: AppConstants.smallLabelSize,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Obx(() {
      final topic = controller.selectedTopic;
      if (topic == null) {
        return const Center(child: Text('Select a topic'));
      }

      final columns = ['Board', 'JEE Main', 'JEE Advanced'];

      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    _buildHeaderRow(columns),
                    // Data Rows
                    ...topic.subtopics.map(
                      (subtopic) => _buildDataRow(subtopic, columns),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Start Assignment Button (below grid)
          Obx(() {
            if (controller.selectedSubtopicId.value == null ||
                controller.selectedColumnKey.value == null) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: const EdgeInsets.all(AppConstants.contentPadding),
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.startAssignment(),
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
                    child: const Text(
                      'Start Assignment',
                      style: TextStyle(fontSize: AppConstants.normalTextSize),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      );
    });
  }

  Widget _buildHeaderRow(List<String> columns) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.contentPadding,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              'Subtopic',
              style: TextStyle(
                fontSize: AppConstants.normalTextSize,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...columns.map(
            (col) => SizedBox(
              width: 100,
              child: Text(
                col,
                style: TextStyle(
                  fontSize: AppConstants.normalTextSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(subtopic, List<String> columns) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.contentPadding,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              subtopic.name,
              style: const TextStyle(
                fontSize: AppConstants.normalTextSize,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...columns.map((col) {
            final score = subtopic.scores[col]?.score ?? 0.0;
            final state = controller.getCircleState(subtopic.id, col);
            return SizedBox(
              width: 100,
              child: Center(
                child: ScoreCircle(
                  score: score,
                  state: state,
                  onTap: () => controller.onCircleTap(subtopic.id, col),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
