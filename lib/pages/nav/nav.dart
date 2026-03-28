import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/auth/login.dart';
import 'package:red_hrcrm/component/createPayroll.dart';
import 'package:red_hrcrm/pages/employee/createEmployee.dart';
import 'package:red_hrcrm/pages/attendance/attendance.dart';
import 'package:red_hrcrm/pages/employee/EmployeeDetailScreen.dart';
import 'package:red_hrcrm/pages/employee/createEmployeesimple.dart';

import 'package:red_hrcrm/pages/nav/shell.dart';
import 'package:red_hrcrm/pages/payroll/payroll.dart';
import 'package:red_hrcrm/pages/staff/staff_dashboard.dart';
import 'package:red_hrcrm/pages/task/task.dart';

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
    //  🔓 AUTH (NO SHELL)
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // 🔒 APP (SHELL ONCE)
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        GoRoute(path: '/', redirect: (_, _) => '/home'),
        GoRoute(path: '/home', builder: (context, state) => Homepage()),
        GoRoute(
          path: '/CreateEmployeePage',
          builder: (context, state) => const CreateEmployeeFullPage(),
        ),
        GoRoute(path: '/Payroll', builder: (context, state) => const Payroll()),
        GoRoute(
          path: '/Attendance',
          builder: (context, state) => const Attendance(),
        ),
        GoRoute(path: '/Task', builder: (context, state) => const Task()),
        GoRoute(
          path: '/createpayroll',
          builder: (context, state) {
            final employeeId = int.parse(
              state.uri.queryParameters['employeeId']!,
            );

            return CreateSalarySlipScreen(employeeId: employeeId);
          },
        ),
        GoRoute(
          path: '/employee-details',
          builder: (context, state) {
            final id = state.extra as int;
            return EmployeeDetailScreen(employeeId: id);
          },
        ),
        GoRoute(
          path: '/employee-details',
          builder: (context, state) {
            final employeeId = state.extra as int;

            return EmployeeDetailScreen(employeeId: employeeId);
          },
        ),
        GoRoute(
          path: '/create-employee',
          name: 'createEmployee',
          builder: (context, state) => const CreateEmployeeFullPage(),
        ),
      ],
    ),
  ],
);

/// 🔁 Forces GoRouter to refresh when Supabase auth changes
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
