import 'package:go_router/go_router.dart';
import 'package:suguna_teachers_app/core/routes/app_routes.dart';
import 'package:suguna_teachers_app/modules/home/bindings/home_binding.dart';
import 'package:suguna_teachers_app/modules/home/views/home_view.dart';
import 'package:suguna_teachers_app/modules/timetable/bindings/timetable_binding.dart';
import 'package:suguna_teachers_app/modules/timetable/views/timetable_view.dart';
import 'package:suguna_teachers_app/modules/batch_control/bindings/batch_control_binding.dart';
import 'package:suguna_teachers_app/modules/batch_control/views/batch_control_view.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/bindings/student_performance_report_binding.dart';
import 'package:suguna_teachers_app/modules/student_performance_report/views/student_performance_report_view.dart';
import 'package:suguna_teachers_app/modules/batch_performance_report/bindings/batch_performance_report_binding.dart';
import 'package:suguna_teachers_app/modules/batch_performance_report/views/batch_performance_report_view.dart';
import 'package:suguna_teachers_app/modules/assignment_control/bindings/assignment_control_binding.dart';
import 'package:suguna_teachers_app/modules/assignment_control/views/assignment_control_view.dart';
import 'package:suguna_teachers_app/modules/phase_plan/bindings/phase_plan_binding.dart';
import 'package:suguna_teachers_app/modules/phase_plan/views/phase_plan_view.dart';
import 'package:suguna_teachers_app/modules/my_library/bindings/my_library_binding.dart';
import 'package:suguna_teachers_app/modules/my_library/views/my_library_view.dart';
import 'package:suguna_teachers_app/modules/attendance/bindings/attendance_binding.dart';
import 'package:suguna_teachers_app/modules/attendance/views/attendance_view.dart';

class RouteConfig {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          HomeBinding().dependencies();
          return const HomeView();
        },
      ),
      GoRoute(
        path: AppRoutes.timetable,
        name: 'timetable',
        builder: (context, state) {
          TimetableBinding().dependencies();
          return const TimetableView();
        },
      ),
      GoRoute(
        path: AppRoutes.batchControl,
        name: 'batchControl',
        builder: (context, state) {
          BatchControlBinding().dependencies();
          return const BatchControlView();
        },
      ),
      GoRoute(
        path: AppRoutes.studentPerformanceReport,
        name: 'studentPerformanceReport',
        builder: (context, state) {
          StudentPerformanceReportBinding().dependencies();
          return const StudentPerformanceReportView();
        },
      ),
      GoRoute(
        path: AppRoutes.batchPerformanceReport,
        name: 'batchPerformanceReport',
        builder: (context, state) {
          BatchPerformanceReportBinding().dependencies();
          return const BatchPerformanceReportView();
        },
      ),
      GoRoute(
        path: AppRoutes.assignmentControl,
        name: 'assignmentControl',
        builder: (context, state) {
          AssignmentControlBinding().dependencies();
          return const AssignmentControlView();
        },
      ),
      GoRoute(
        path: AppRoutes.phasePlan,
        name: 'phasePlan',
        builder: (context, state) {
          PhasePlanBinding().dependencies();
          return const PhasePlanView();
        },
      ),
      GoRoute(
        path: AppRoutes.myLibrary,
        name: 'myLibrary',
        builder: (context, state) {
          MyLibraryBinding().dependencies();
          return const MyLibraryView();
        },
      ),
      GoRoute(
        path: AppRoutes.attendance,
        name: 'attendance',
        builder: (context, state) {
          AttendanceBinding().dependencies();
          return const AttendanceView();
        },
      ),
    ],
  );
}
