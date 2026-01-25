

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/modules/test_player/controllers/test_player_controller.dart';

import '../../../core/theme/app_colors.dart';

class QuestionOptionsWidget extends StatelessWidget {
  const QuestionOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TestPlayerController>(builder: (controller){
      return Obx(() {
        final question = controller.currentQuestion;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Question ${question.number}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => Text(
                question.text,
                style: TextStyle(
                  fontSize: controller.getQuestionFontSize(),
                  height: 1.6,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              )),
              const SizedBox(height: 16),
              _buildQuestionWidget(question,controller),
            ],
          ),
        );
      });
    });
  }

  Widget _buildQuestionWidget(Question question,TestPlayerController controller) {
    switch (question.type) {
      case QuestionType.mcqSingle:
        return _buildMCQSingle(question,controller);
      case QuestionType.mcqMultiple:
        return _buildMCQMultiple(question,controller);
      case QuestionType.MatchTheFollowing:
        return _buildMAQ(question,controller);
      case QuestionType.numerical:
        return _buildNumerical(question);
      case QuestionType.trueFalse:
        return _buildTrueFalse(question,controller);
      case QuestionType.singleDropdown:
        return _buildSingleDropdown(question);
      case QuestionType.multiDropdown:
        return _buildMultiDropdown(question);
      case QuestionType.textType:
        return _buildTextType(question);
      case QuestionType.subjective:
        return _buildSubjective(question,controller);
      }
  }

  // MCQ - Single Answer
  Widget _buildMCQSingle(Question question,TestPlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.options
          .map((option) => _buildOption(
        controller: controller,
        label: String.fromCharCode(65 + question.options.indexOf(option)),
        text: option,
        isSelected: question.selectedAnswer == option,
        onTap: () => controller.selectAnswer(option),
      )).toList(),
    );
  }

  // MCQ - Multiple Answer
  Widget _buildMCQMultiple(Question question,TestPlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
              SizedBox(width: 8),
              Text(
                'Select all correct answers',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ),
        ...question.options
            .map((option) => _buildMultiOption(
          controller: controller,
          label: String.fromCharCode(65 + question.options.indexOf(option)),
          text: option,
          isSelected: question.selectedAnswers?.contains(option) ?? false,
          onTap: () => controller.selectAnswer(option),
        )),
      ],
    );
  }

  Widget _buildMultiOption({
    required String label,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
   required TestPlayerController controller
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => Text(
                    text,
                    style: TextStyle(
                      fontSize: controller.getOptionFontSize(),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  )),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_box_rounded,
                    color: AppColors.primary,
                    size: 24,
                  )
                else
                  Icon(
                    Icons.check_box_outline_blank_rounded,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Match the Following
  Widget _buildMAQ(Question question,TestPlayerController controller
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Match items from Column A with Column B',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        ...question.matchPairs!.map((pair) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Obx(() => Text(
                    pair.left,
                    style: TextStyle(
                      fontSize: controller.getOptionFontSize(),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  )),
                ),
                const SizedBox(width: 16),
                Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: GetBuilder<TestPlayerController>(
                    id: 'question',
                    builder: (_) {
                      return DropdownButtonFormField<String>(
                        value: question.matchAnswers?[pair.left],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        hint: const Text('Select', style: TextStyle(fontSize: 13)),
                        items: pair.rightOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option, style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectMatch(pair.left, value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Numerical Answer
  Widget _buildNumerical(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calculate_outlined, color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 8),
              Text(
                'Enter numerical value${question.minRange != null ? " (Range: ${question.minRange} - ${question.maxRange})" : ""}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),
        GetBuilder<TestPlayerController>(
          builder: (controller) {
            return TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(20),
              ),
              style: TextStyle(
                fontSize: controller.getOptionFontSize(),
                fontWeight: FontWeight.w600,
              ),
              onChanged: (value) {
                final num = double.tryParse(value);
                if (num != null) {
                  controller.setNumericalAnswer(num);
                }
              },
            );
          },
        ),
      ],
    );
  }

  // True/False
  Widget _buildTrueFalse(Question question,  TestPlayerController controller
      ) {
    return Row(
      children: question.options.map((option) {
        final isTrue = option == 'True';
        final isSelected = question.selectedAnswer == option;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: isTrue ? 12 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectAnswer(option),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isTrue ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (isTrue ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isTrue ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 48,
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Obx(() => Text(
                        option,
                        style: TextStyle(
                          fontSize: controller.getOptionFontSize() + 2,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Single Dropdown
  Widget _buildSingleDropdown(Question question) {
    return GetBuilder<TestPlayerController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: question.selectedAnswer,
            decoration: const InputDecoration(
              labelText: 'Select your answer',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: question.options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Obx(() => Text(
                  option,
                  style: TextStyle(fontSize: controller.getOptionFontSize()),
                )),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectAnswer(value);
              }
            },
          ),
        );
      },
    );
  }

  // Multi Dropdown
  Widget _buildMultiDropdown(Question question) {
    return GetBuilder<TestPlayerController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.checklist_rounded, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Select multiple options from dropdown',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            ...question.options.map((option) {
              final isSelected = question.selectedAnswers?.contains(option) ?? false;
              return CheckboxListTile(
                title: Obx(() => Text(
                  option,
                  style: TextStyle(fontSize: controller.getOptionFontSize()),
                )),
                value: isSelected,
                onChanged: (value) => controller.selectAnswer(option),
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              );
            }),
          ],
        );
      },
    );
  }

  // Text Type
  Widget _buildTextType(Question question) {
    return GetBuilder<TestPlayerController>(
      builder: (controller) {
        return TextField(
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.all(20),
          ),
          style: TextStyle(
            fontSize: controller.getOptionFontSize(),
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) => controller.setTextAnswer(value),
        );
      },
    );
  }

  // Subjective
  Widget _buildSubjective(Question question,TestPlayerController controller) {
    return GetBuilder<TestPlayerController>(
      id: 'question',
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.edit_note_rounded, color: Color(0xFF8B5CF6), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Write detailed answer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Type your answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.all(20),
              ),
              style: TextStyle(
                fontSize: controller.getOptionFontSize(),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              onChanged: (value) => controller.setTextAnswer(value),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption({
    required String label,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required TestPlayerController controller
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => Text(
                    text,
                    style: TextStyle(
                      fontSize: controller.getOptionFontSize(),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  )),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}