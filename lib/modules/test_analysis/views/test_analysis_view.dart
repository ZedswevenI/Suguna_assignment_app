import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suguna_assignment_app/data/services/sessions.dart';

import '../../../core/routes/app_routes.dart';
import '../../test_player/controllers/test_player_controller.dart';
import '../../test_player/controllers/test_player_parser.dart';
import '../../test_player/views/test_review_view.dart';

class TestAnalysisView extends StatelessWidget {
  const TestAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: TestPlayerController(),
        builder: (controller){
      return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          body: SafeArea(
            child: Column(
              children: [
                _buildDashboardHeader(controller),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildPerformanceReport(controller),
                        const SizedBox(height: 24),
                        _buildPerformanceChart(controller),
                        const SizedBox(height: 24),
                        _buildKeyMetrics(controller),
                        const SizedBox(height: 24),
                        _buildQuestionsSection(controller),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ============================================================
  // DASHBOARD HEADER
  // ============================================================
  Widget _buildDashboardHeader(TestPlayerController controller) {
    return Container(
      color: const Color(0xFFFF5C00),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.home);
                    },
                    icon: const Icon(Icons.close_rounded, size: 20),
                    label: const Text('Exit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  if(!Session.instance.isCompletedAssignment)...[
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        _showRetestConfirmation(controller);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFD84040),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reattempt',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        _showFinalizeConfirmation(controller);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFD84040),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Finalize',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]

                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Title and details
          const Text(
            'Test Analysis',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 Text(
                  'ENo: ${Session.instance.currentUser!['data']['admissionNo']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  '${Session.instance.selectedSubtopic?.name} | ${Session.instance.selectedSub} | 30 min',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 24),
                if(controller.selectedQuestions['data'] != null)Text(
                  'Test ID: ${controller.selectedQuestions['data']['testNo']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KEY METRICS - SINGLE HORIZONTAL LINE
  // ============================================================
  Widget _buildKeyMetrics(TestPlayerController controller) {
    final stats = controller.getTestStatistics();

    final total = stats['total'] as int;
    final correct = stats['correct'] as int;
    final wrong = stats['wrong'] as int;
    final skipped = stats['skipped'] as int;
    final percentage = stats['percentage'] as double;



    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetricCard(
          "Total Questions",
          total.toString(),
          const Color(0xFF3B82F6),
          Icons.quiz_outlined,
        ),
        const SizedBox(width: 18),
        _buildMetricCard(
          "Correct",
          correct.toString(),
          const Color(0xFF10B981),
          Icons.check_circle_outline,
        ),
        const SizedBox(width: 18),
        _buildMetricCard(
          "Wrong",
          wrong.toString(),
          const Color(0xFFEF4444),
          Icons.cancel_outlined,
        ),
        const SizedBox(width: 18),
        _buildMetricCard(
          "Accuracy",
          "${percentage.toStringAsFixed(0)}%",
          const Color(0xFFF59E0B),
          Icons.trending_up,
        ),
        // const SizedBox(width: 18),
        // SizedBox(
        //   width: Get.width * 0.2,
        //   child:   _buildDonutChart(
        //     percentage: totalScore,
        //     correct: stats['correct'] as int,
        //     wrong: (stats['wrong'] as int) + stats['skipped'] as int,
        //     skipped: 0,
        //   ),
        // )
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PERFORMANCE CHART
  // ============================================================
  Widget _buildPerformanceChart(TestPlayerController controller) {
    final stats = controller.getTestStatistics();

    final total = stats['total'] as int;
    final correct = stats['correct'] as int;
    final wrong = stats['wrong'] as int;
    final skipped = stats['skipped'] as int;
    final report = controller.getPerformanceReport();

    final totalScore = report["totalScore"];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              SizedBox(
                width: Get.width * 0.2,
                child:   _buildDonutChart(
                  percentage: totalScore,
                  correct: stats['correct'] as int,
                  wrong: (stats['wrong'] as int) + stats['skipped'] as int,
                  skipped: 0,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    /// ===== CHART BARS =====
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        _buildChartBar(
                          'Correct',
                          correct,
                          total,
                          const Color(0xFF10B981),
                        ),
                        _buildChartBar(
                          'Wrong',
                          wrong,
                          total,
                          const Color(0xFFEF4444),
                        ),
                        _buildChartBar(
                          'Skipped',
                          skipped,
                          total,
                          const Color(0xFFAB8F4A),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// ===== LEGEND =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem('Correct', const Color(0xFF10B981)),
                        _buildLegendItem('Wrong', const Color(0xFFEF4444)),
                        _buildLegendItem('Skipped', const Color(0xFFAB8F4A)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
  Widget _buildChartBar(String label, int value, int total, Color color) {
    final percentage = total == 0
        ? 0.0
        : (value / total) * 100;    return Column(
      children: [
        Container(
          width: 50,
          height: percentage * 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceReport(TestPlayerController controller) {
    final report = controller.getPerformanceReport();

    final totalQuestions = report["totalMarks"];
    final correct = report["correct"];
    final wrong = report["wrong"];
    final positiveMarks = report["positiveMarks"];
    final negativeMarks = report["negativeMarks"];
    final totalScore = report["totalScore"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   color: const Color(0xFF1E3A8A),
        //   child: ,
        // ),
        // const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF009741),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              const Text(
                'Performance Breakdown',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ).marginOnly(left: 16),
              SizedBox(height: 8,),
              // HEADER
              _buildHeaderRow(),
              // SUBJECT ROW
              _buildPerformanceRow(
                Session.instance.selectedSubject?.name ?? '',
                totalScore.toStringAsFixed(1),
                correct.toString(),
                '+${positiveMarks.toStringAsFixed(1)}',
                wrong.toString(),
                '-${negativeMarks.toStringAsFixed(1)}',
              ),

              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),

              // TOTAL ROW
              _buildPerformanceRow(
                'TOTAL',
                '${totalScore.toStringAsFixed(1)} out of ${totalQuestions.toStringAsFixed(1)}',
                correct.toString(),
                '+${positiveMarks.toStringAsFixed(1)}',
                wrong.toString(),
                '-${negativeMarks.toStringAsFixed(1)}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Subjective type question marks are based on self evaluation.',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child:  Row(
        children: [
          Expanded(flex: 2, child: Text('Subject', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
          Expanded(flex: 2, child: Text('Your score', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
          Expanded(flex: 2, child: Text('Answered correct', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
          Expanded(flex: 2, child: Text('Positive marks', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
          Expanded(flex: 2, child: Text('Answered incorrect', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
          Expanded(flex: 2, child: Text('Negative marks', style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ))),
        ],
      ),
    );
  }


  Widget _buildPerformanceRow(
      String subject,
      String score,
      String correct,
      String positive,
      String incorrect,
      String negative,
      ) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: const Color(0xFF22650B),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                subject,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              score,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFD700),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              correct,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              positive,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              incorrect,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              negative,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection(TestPlayerController controller) {
    final questions = controller.getAllQuestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF009741),
          ),
          child:  Text(
            '${Session.instance.selectedSubject?.name}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,

              color: Colors.white,
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF009741),
          ),
          child: const Row(
            children: [
              Expanded(flex: 1, child: Text('Q', style: TextStyle(color: Colors.white))),
              Expanded(flex: 3, child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Type', style: TextStyle(color: Colors.white)))),
              Expanded(flex: 2, child: Text('You Marked', style: TextStyle(color: Colors.white))),
              Expanded(flex: 2, child: Text('Your marks', style: TextStyle(color: Colors.white))),
              Expanded(flex: 1, child: Text('View', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),

        ...questions.map((q) {
          final userAnswer = controller.getUserAnswerDisplay(q);
          final isCorrect = controller.isCorrect(q);
          final isSkipped = controller.isQuestionSkipped(q);
          double marks = 0;
          if (isSkipped) {
            marks = 0;
          } else if (isCorrect) {
            marks = q.positiveMarks;
          } else {
            marks = double.parse("-${q.negativeMarks}".toString());
          }

          return _buildQuestionRowDynamic(
            controller: controller,
            question: q,
            userAnswer: userAnswer,
            isCorrect: isCorrect,
            mark : marks,
          );
        }),
      ],
    );
  }

  Widget _buildQuestionRowDynamic({
    required TestPlayerController controller,
    required Question question,
    required String userAnswer,
    required bool isCorrect,
    required double mark,

  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF22650B),
      ),
      child: Row(
        spacing: 16,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              question.number.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _getQuestionTypeName(question.type),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              userAnswer,
              style: const TextStyle(
                color: Color(0xFF00D4FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text( "$mark",
              style: TextStyle(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.showAnswer.value = true;
                    controller.goToReviewQuestion(question.number - 1);
                    Get.toNamed(AppRoutes.testReview, arguments: {
                      'index': question.number - 1,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'With Answer',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    controller.showAnswer.value = false;
                    controller.goToReviewQuestion(question.number - 1);
                    Get.toNamed(AppRoutes.testReview, arguments: {
                      'index': question.number - 1,
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:  Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Without Answer',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionRow(
      String questionNo,
      String questionType,
      String marked,
      String marks,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E4DA3),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              questionNo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                questionType,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              marked,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00D4FF),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              marks,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Click',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00D4FF),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChart({
    required double percentage,
    required int correct,
    required int wrong,
    required int skipped,
  }) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Donut Chart
          CustomPaint(
            size: const Size(180, 180),
            painter: DonutChartPainter(
              correct: correct,
              wrong: wrong,
              skipped: skipped,
            ),
          ),

          // Center Content
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  percentage.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  'Score',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getQuestionTypeName(QuestionType type) {
    switch (type) {
      case QuestionType.mcqSingle:
        return 'MCQ Single';
      case QuestionType.mcqMultiple:
        return 'MCQ Multiple';
      case QuestionType.numerical:
        return 'Numerical';
      case QuestionType.textType:
        return 'Short Answer';
      case QuestionType.subjective:
        return 'Subjective';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.matchTheFollowing:
        return 'Match';
      default:
        return 'MCQ';
    }
  }


  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return const Color(0xFF10B981);
    if (percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }


  void _showRetestConfirmation(TestPlayerController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.refresh_rounded, color: Color(0xFF8B5CF6)),
            SizedBox(width: 12),
            Text('Retest?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to retake this test? All your current answers will be cleared and the timer will restart.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.until((route) => route.settings.name == AppRoutes.assignmentInstructions);
              Get.toNamed(AppRoutes.assignmentInstructions);
              Session.instance.isRetest = true;
              // controller.takeRetest();
            },
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Restart Test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }


  void _showFinalizeConfirmation(TestPlayerController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.refresh_rounded, color: Color(0xFF8B5CF6)),
            SizedBox(width: 12),
            Text('Finalize ?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to finalize this test ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              controller.submitTestResults();
              // controller.takeRetest();
            },
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }
}