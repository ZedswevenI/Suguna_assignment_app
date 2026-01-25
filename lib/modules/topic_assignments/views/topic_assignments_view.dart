import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/core/constants/app_constants.dart';
import 'package:suguna_assignment_app/core/routes/app_routes.dart';
import 'package:suguna_assignment_app/core/theme/app_colors.dart';
import 'package:suguna_assignment_app/core/utils/responsive_helper.dart';
import 'package:suguna_assignment_app/core/widgets/app_layout.dart';
import 'package:suguna_assignment_app/data/models/subject_model.dart';
import 'package:suguna_assignment_app/modules/topic_assignments/controllers/topic_assignments_controller.dart';
import '../../../core/widgets/score_circle.dart';

class TopicAssignmentsView extends GetView<TopicAssignmentsController> {
  const TopicAssignmentsView({super.key});

  static const List<String> _columns = [
    'Board',
    'JEE Main',
    'JEE Advanced',
  ];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      selectedRoute: AppRoutes.topicAssignments,
      subjectName: controller.subject.name,
      classInfo: controller.subject.classInfo,
      assignmentLabel: 'Assignment',
      showSidebar: false,
      showBackButton: true,
      child: _buildModernLayout(context),
    );
  }

  Widget _buildModernLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8F9FC),
            const Color(0xFFEEF2F7),
          ],
        ),
      ),
      padding: ResponsiveHelper.getPadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernTopicPanel(),
          const SizedBox(width: 20),
          Expanded(child: _buildModernMatrix()),
        ],
      ),
    );
  }

  // ============================================================
  // MODERN TOPIC PANEL WITH GLASSMORPHISM
  // ============================================================

  Widget _buildModernTopicPanel() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildPanelHeader(),
            Expanded(child: _buildTopicList()),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelHeader() {
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
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.format_list_bulleted_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Topics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicList() {
    return Obx(() {
      final selectedId = controller.selectedTopicId.value;
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.topics.length,
        itemBuilder: (_, index) {
          final topic = controller.topics[index];
          final isSelected = selectedId == topic.id;

          return TweenAnimationBuilder<double>(
            key: ValueKey(topic.id),
            duration: const Duration(milliseconds: 200),
            tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
            builder: (context, value, child) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.12 * value),
                      AppColors.primary.withOpacity(0.05 * value),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3 * value),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15 * value),
                      blurRadius: 8 * value,
                      offset: Offset(0, 2 * value),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.selectTopic(topic.id),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              topic.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  // ============================================================
  // MODERN MATRIX WITH ELEVATED CARD DESIGN
  // ============================================================

  Widget _buildModernMatrix() {
    return Obx(() {
      final topic = controller.selectedTopic;

      if (topic == null) {
        return _buildEmptyState();
      }

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: topic.subtopics
                        .map((s) => _buildModernDataRow(s))
                        .toList(),
                  ),
                ),
              ),
              _buildModernCTA(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.topic_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Select a topic to view assignments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF8F9FC),
            Colors.white.withOpacity(0.9),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: Text(
              'Subtopic',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary.withOpacity(0.7),
                letterSpacing: 0.8,
              ),
            ),
          ),
          ..._columns.map(
                (c) => SizedBox(
              width: 140,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDataRow(subtopic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: Text(
              subtopic.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ..._columns.map(
                (col) => SizedBox(
              width: 140,
              child: Center(
                child: ModernAssignmentDot(
                  state: controller.getCircleState(subtopic.id, col),
                  selected: controller.isSubtopicSelected(subtopic.id, col),
                  onTap: () => controller.onCircleTap(subtopic.id, col),
                  // Add these methods to your controller to get status and score
                  status: controller.getAssignmentStatus(subtopic.id, col),
                  scoreLevel: controller.getScoreLevel(subtopic.id, col),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCTA() {
    return Obx(() {
      final isVisible = controller.selectedSubtopicId.value != null &&
          controller.selectedColumnKey.value != null;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isVisible ? 80 : 0,
        curve: Curves.easeInOut,
        child: isVisible
            ? Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFF8F9FC),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.border.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: controller.startAssignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Start Assignment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        )
            : const SizedBox.shrink(),
      );
    });
  }
}

// ============================================================
// MODERN ASSIGNMENT DOT WITH ANIMATIONS
// ============================================================

enum AssignmentStatus {
  notOpened,      // Black - not yet opened by teacher
  available,      // White - opened and ready to attempt
  locked,         // Grey - opened but need previous level(s)
  attempted,      // Has score (use scoreLevel for color)
}

enum ScoreLevel {
  none,           // No score yet
  extremelyPoor,  // Red
  poor,           // Light Red
  notGood,        // Orange
  moderate,       // Yellow
  satisfactory,   // Light Green
}

class ModernAssignmentDot extends StatefulWidget {
  final CircleState state;
  final bool selected;
  final VoidCallback onTap;
  final AssignmentStatus? status;
  final ScoreLevel? scoreLevel;

  const ModernAssignmentDot({
    super.key,
    required this.state,
    required this.selected,
    required this.onTap,
    this.status,
    this.scoreLevel,
  });

  @override
  State<ModernAssignmentDot> createState() => _ModernAssignmentDotState();
}

class _ModernAssignmentDotState extends State<ModernAssignmentDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    Color borderColor;
    Widget? icon;

    // Handle CircleState first (downloading/downloaded override status)
    if (widget.state == CircleState.downloading) {
      color = const Color(0xFF6366F1); // Purple
      borderColor = const Color(0xFF818CF8);
      icon = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (widget.state == CircleState.downloaded) {
      color = const Color(0xFF10B981); // Green
      borderColor = const Color(0xFF34D399);
      icon = const Icon(Icons.check_rounded, size: 18, color: Colors.white);
    } else {
      // Use status and scoreLevel for other states
      if (widget.status == AssignmentStatus.attempted && widget.scoreLevel != null) {
        // Show color based on score
        switch (widget.scoreLevel!) {
          case ScoreLevel.extremelyPoor:
            color = const Color(0xFFDC2626); // Red
            borderColor = const Color(0xFFEF4444);
            break;
          case ScoreLevel.poor:
            color = const Color(0xFFF87171); // Light Red
            borderColor = const Color(0xFFFCA5A5);
            break;
          case ScoreLevel.notGood:
            color = const Color(0xFFF97316); // Orange
            borderColor = const Color(0xFFFB923C);
            break;
          case ScoreLevel.moderate:
            color = const Color(0xFFFBBF24); // Yellow
            borderColor = const Color(0xFFFCD34D);
            break;
          case ScoreLevel.satisfactory:
            color = const Color(0xFF84CC16); // Light Green
            borderColor = const Color(0xFFA3E635);
            break;
          case ScoreLevel.none:
            color = const Color(0xFFE5E7EB);
            borderColor = const Color(0xFFD1D5DB);
        }
      } else {
        // Show status-based color
        switch (widget.status ?? AssignmentStatus.notOpened) {
          case AssignmentStatus.notOpened:
            color = const Color(0xFF1F2937); // Black
            borderColor = const Color(0xFF374151);
            break;
          case AssignmentStatus.available:
            color = Colors.white; // White
            borderColor = const Color(0xFFD1D5DB);
            break;
          case AssignmentStatus.locked:
            color = const Color(0xFF9CA3AF); // Grey
            borderColor = const Color(0xFFD1D5DB);
            icon = const Icon(Icons.lock_outline_rounded, size: 14, color: Colors.white);
            break;
          case AssignmentStatus.attempted:
            color = const Color(0xFFE5E7EB);
            borderColor = const Color(0xFFD1D5DB);
        }
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = 1.0 - (_controller.value * 0.1);
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isHovered || widget.selected ? 46 : 42,
                height: _isHovered || widget.selected ? 46 : 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.selected
                        ? AppColors.primary
                        : borderColor.withOpacity(0.5),
                    width: widget.selected ? 3 : 1.5,
                  ),
                  boxShadow: [
                    if (widget.selected || _isHovered)
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: icon == null ? null : Center(child: icon),
              ),
            );
          },
        ),
      ),
    );
  }
}