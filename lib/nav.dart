import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/auth/login.dart';
import 'package:red_hrcrm/component/employeeinfo.dart';
import 'package:red_hrcrm/employee_form.dart';
import 'package:red_hrcrm/homepage.dart';
import 'package:red_hrcrm/shell.dart';

final firebaseAuth = FirebaseAuth.instance;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable:
      GoRouterRefreshStream(firebaseAuth.authStateChanges()),
 
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
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
   
    // 🔒 APP (SHELL ONCE)
    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          redirect: (_, _) => '/home',
        ),
         GoRoute(
          path: '/home',
           builder: (context, state) => Homepage(),
        ),
         GoRoute(
      path: '/CreateEmployeePage',
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
