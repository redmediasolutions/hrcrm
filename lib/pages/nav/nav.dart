import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/auth/login.dart';
import 'package:red_hrcrm/component/createPayroll.dart';
import 'package:red_hrcrm/pages/employee/createEmployee.dart';
import 'package:red_hrcrm/pages/attendance/attendance.dart';
import 'package:red_hrcrm/pages/employee/createEmployeesimple.dart';
import 'package:red_hrcrm/pages/employee/employeedetails/employee_detail_screen.dart';
import 'package:red_hrcrm/pages/nav/shell.dart';
import 'package:red_hrcrm/pages/payroll/payrolldetails.dart';
import 'package:red_hrcrm/pages/staff/staff_dashboard.dart';
import 'package:red_hrcrm/pages/reports/reports.dart';

final firebaseAuth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),

  redirect: (context, state) {
    final user = firebaseAuth.currentUser;
    final loggedIn = user != null;
    final isLogin = state.uri.path == '/login';

    if (!loggedIn && !isLogin) return '/login';
    if (loggedIn && isLogin) return '/home';

    return null;
  },

  routes: [
    // 🔓 AUTH
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // 🔒 APP (SHELL)
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        // Redirect root → home
        GoRoute(path: '/', redirect: (_, _) => '/home'),

        // 🏠 Dashboard
        GoRoute(
          path: '/home',
          builder: (context, state) => Homepage(),
        ),

        // 👥 Employees
        GoRoute(
          path: '/employees/create',
          builder: (context, state) => const CreateEmployeeFullPage(),
        ),
        GoRoute(
          path: '/employees/simple-create',
          name: 'createEmployee',
          builder: (context, state) => const CreateEmployeeSimplePage(),
        ),
        GoRoute(
          path: '/employees/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EmployeeDetailScreen(employeeId: id);
          },
        ),

        // 💰 Payroll
        GoRoute(
          path: '/payroll',
          builder: (context, state) => const PayrollDetails(),
        ),
        GoRoute(
          path: '/payroll/create',
          builder: (context, state) {
            final employeeId = int.parse(
              state.uri.queryParameters['employeeId']!,
            );
            return CreateSalarySlipScreen(employeeId: employeeId);
          },
        ),

        // 📅 Attendance
        GoRoute(
          path: '/attendance',
          builder: (context, state) => const Attendance(),
        ),

        // ✅ Tasks
        GoRoute(
          path: '/reports',
          builder: (context, state) => const Reports(),
        ),
      ],
    ),
  ],
);

/// 🔁 Forces GoRouter to refresh when auth changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
