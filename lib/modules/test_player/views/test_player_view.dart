import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/modules/test_player/views/question_options_widget.dart';

import '../controllers/test_player_controller.dart';

class TestPlayerView extends StatelessWidget {
  const TestPlayerView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TestPlayerController>(
        id: 'palette',
        builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildQuestionPanel(controller)),
                    _buildQuestionPalette(controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });

  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.book_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Mathematics - JEE Main',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEF4444),
                  const Color(0xFFDC2626),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '45:30',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    // fontFeatureSettings: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () => {

            },
            icon: const Icon(Icons.exit_to_app_rounded, size: 18),
            label: const Text('Exit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => {

            },
            icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
            label: const Text('Submit Test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUESTION PANEL WITH CATEGORY TABS
  // ============================================================

  Widget _buildQuestionPanel(TestPlayerController controller) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(child: QuestionOptionsWidget()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return GetBuilder<TestPlayerController>(builder: (controller) {
      return Obx(() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF8F9FC),
              Colors.white,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: List.generate(
                    controller.categories.length,
                        (index) {
                      final category = controller.categories[index];
                      final isSelected = controller.currentCategoryIndex.value == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryTab(
                          category: category,
                          isSelected: isSelected,
                          onTap: () => controller.selectCategory(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  _buildTextSizeButton(0, 'A'),
                  const SizedBox(width: 4),
                  _buildTextSizeButton(1, 'A+'),
                  const SizedBox(width: 4),
                  _buildTextSizeButton(2, 'A++'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: OutlinedButton.icon(
                onPressed: () => {

                },
                icon: const Icon(Icons.flag_outlined, size: 16),
                label: const Text('Report'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: BorderSide(color: const Color(0xFFEF4444).withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }

  Widget _buildTextSizeButton(int size, String label) {
    return GetBuilder<TestPlayerController>(builder: (controller){
      final isSelected = controller.textSize.value == size;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setTextSize(size),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    });

  }

  Widget _buildCategoryTab({
    required QuestionCategory category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            )
                : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category.questionCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return GetBuilder<TestPlayerController>(builder: (controller){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            // Previous Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.previous(),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Previous', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Clear Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.clearResponse(),
                icon: const Icon(Icons.clear_rounded, size: 16),
                label: const Text('Clear', style: TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Save & Mark
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.saveAndMarkForReview(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save & Mark', style: TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(width: 8),

            // Mark & Next
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.markForReviewAndNext(),
                label: const Text('Mark & Next', style: TextStyle(fontSize: 13)),
                icon: const Icon(Icons.bookmark_border_rounded, size: 16),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Save & Next
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.saveAndNext(),
                label: const Text('Save & Next', style: TextStyle(fontSize: 13)),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });

  }

  // ============================================================
  // QUESTION PALETTE
  // ============================================================

  Widget _buildQuestionPalette(TestPlayerController controller) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPaletteHeader(),
          Flexible(child: _buildCategoryPalettes()),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildPaletteHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          const Text(
            'Question Palette',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return GetBuilder<TestPlayerController>(
      builder: (controller) {
        // Calculate totals across all categories
        int answeredCount = 0;
        int notAnsweredCount = 0;
        int markedCount = 0;
        int answeredAndMarkedCount = 0;
        int notVisitedCount = 0;

        for (var category in controller.categories) {
          for (var question in category.questions) {
            switch (question.status) {
              case QuestionStatus.answered:
                answeredCount++;
                break;
              case QuestionStatus.notAnswered:
                notAnsweredCount++;
                break;
              case QuestionStatus.markedForReview:
                markedCount++;
                break;
              case QuestionStatus.answeredAndMarked:
                answeredAndMarkedCount++;
                break;
              case QuestionStatus.notVisited:
                notVisitedCount++;
                break;
            }
          }
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _buildLegendItem(
                color: const Color(0xFF10B981),
                label: 'Answered',
                icon: Icons.check_circle_rounded,
                count: answeredCount,
              ),
              const SizedBox(height: 6),
              _buildLegendItem(
                color: const Color(0xFFEF4444),
                label: 'Not Answered',
                icon: Icons.cancel_rounded,
                count: notAnsweredCount,
              ),
              const SizedBox(height: 6),
              _buildLegendItem(
                color: const Color(0xFFF59E0B),
                label: 'Marked',
                icon: Icons.bookmark_rounded,
                count: markedCount,
              ),
              const SizedBox(height: 6),
              _buildLegendItem(
                color: const Color(0xFF8B5CF6),
                label: 'Ans & Marked',
                icon: Icons.bookmark_added_rounded,
                count: answeredAndMarkedCount,
              ),
              const SizedBox(height: 6),
              _buildLegendItem(
                color: const Color(0xFF6B7280),
                label: 'Not Visited',
                icon: Icons.circle_outlined,
                count: notVisitedCount,
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildCategoryPalettes() {
    return GetBuilder<TestPlayerController>(builder: (controller){
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: controller.categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = controller.categories[categoryIndex];

          return Obx(() {
            final isCurrentCategory = controller.currentCategoryIndex.value == categoryIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isCurrentCategory
                    ? AppColors.primary.withOpacity(0.05)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrentCategory
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isCurrentCategory ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isCurrentCategory
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${category.questionCount}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isCurrentCategory ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GetBuilder<TestPlayerController>(
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: List.generate(
                            category.questions.length,
                                (questionIndex) {
                              final question = category.questions[questionIndex];
                              final isCurrent = isCurrentCategory &&
                                  controller.currentQuestionIndex.value == questionIndex;
                              return _buildQuestionNumber(
                                number: question.number,
                                status: question.status,
                                isCurrent: isCurrent,
                                onTap: () => controller.selectQuestion(categoryIndex, questionIndex),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          });
        },
      );
    });

  }


  Widget _buildQuestionNumber({
    required int number,
    required QuestionStatus status,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    Color bgColor;
    IconData? icon;

    switch (status) {
      case QuestionStatus.answered:
        bgColor = const Color(0xFF10B981);
        icon = Icons.check_circle_rounded;
        break;
      case QuestionStatus.notAnswered:
        bgColor = const Color(0xFFEF4444);
        icon = Icons.cancel_rounded;
        break;
      case QuestionStatus.markedForReview:
        bgColor = const Color(0xFFF59E0B);
        icon = Icons.bookmark_rounded;
        break;
      case QuestionStatus.answeredAndMarked:
        bgColor = const Color(0xFF8B5CF6);
        icon = Icons.bookmark_added_rounded;
        break;
      case QuestionStatus.notVisited:
        bgColor = const Color(0xFF6B7280);
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: isCurrent
                ? Border.all(color: AppColors.textPrimary, width: 2.5)
                : null,
            boxShadow: isCurrent
                ? [
              BoxShadow(
                color: bgColor.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (icon != null)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Icon(
                    icon,
                    size: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}