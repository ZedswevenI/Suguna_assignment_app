import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_controller.dart';

class TestPlayerView extends GetView<TestPlayerController> {
  const TestPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Test Player',
          style: TextStyle(color: AppColors.textWhite),
        ),
        elevation: 0,
      ),
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
    return Column(
      children: [
        // Main Content Area
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Row(
              children: [
                // Left 70% - Question + Options
                Expanded(flex: 7, child: _buildQuestionArea(context)),
                // Right 30% - Question Palette
                Expanded(flex: 3, child: _buildQuestionPalette(context)),
              ],
            ),
          ),
        ),
        // Bottom Action Bar
        _buildActionBar(context),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Main Content Area
        Expanded(
          child: Row(
            children: [
              // Left 70% - Question + Options
              Expanded(flex: 7, child: _buildQuestionArea(context)),
              // Right 30% - Question Palette
              Expanded(flex: 3, child: _buildQuestionPalette(context)),
            ],
          ),
        ),
        // Bottom Action Bar
        _buildActionBar(context),
      ],
    );
  }

  Widget _buildQuestionArea(BuildContext context) {
    return Obx(() {
      final question = controller.getCurrentQuestion();
      if (question == null) {
        return const Center(child: Text('No question'));
      }

      return SingleChildScrollView(
        padding: ResponsiveHelper.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${question.questionNumber}',
              style: const TextStyle(
                fontSize: AppConstants.sectionTitleSize,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: AppConstants.normalTextSize,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = controller.selectedAnswerIndex.value == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => controller.selectAnswer(index),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: AppConstants.normalTextSize,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionPalette(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: ResponsiveHelper.getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Question Palette',
            style: TextStyle(
              fontSize: AppConstants.normalTextSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final question = controller.questions[index];
                  final isCurrent =
                      controller.currentQuestionIndex.value == index;

                  Color getStatusColor() {
                    if (question.isMarked) return AppColors.marked;
                    if (question.isAnswered) return AppColors.answered;
                    return AppColors.notVisited;
                  }

                  return InkWell(
                    onTap: () =>
                        controller.goToQuestion(question.questionNumber),
                    child: Container(
                      decoration: BoxDecoration(
                        color: getStatusColor(),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : AppColors.border,
                          width: isCurrent ? 2 : 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${question.questionNumber}',
                          style: TextStyle(
                            fontSize: AppConstants.smallLabelSize,
                            color: question.isVisited
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: ResponsiveHelper.getHorizontalPadding(context),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton('Save & Next', controller.saveAndNext),
          _buildActionButton('Clear', controller.clearAnswer),
          _buildActionButton('Save & Mark', controller.markQuestion),
          _buildActionButton('Mark & Next', controller.markAndNext),
          _buildActionButton('Submit', controller.submit),
          _buildActionButton('Report', controller.showReport),
          _buildActionButton('Exit', controller.exit),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppConstants.smallLabelSize,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
