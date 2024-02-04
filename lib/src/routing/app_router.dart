import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/common_widgets/dialog_page.dart';

import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:riverpod_todo_app/src/features/authentication/sign_in/email_password_sign_in_screen.dart';
import 'package:riverpod_todo_app/src/features/authentication/sign_in/email_password_sign_in_state.dart';
import 'package:riverpod_todo_app/src/features/edit_task/presentation/edit_task_screen.dart';
import 'package:riverpod_todo_app/src/features/statistics/presentation/statistics_screen.dart';
import 'package:riverpod_todo_app/src/common_widgets/task_list_screen.dart';
import 'package:riverpod_todo_app/src/routing/go_router_refresh_stream.dart';
import 'package:riverpod_todo_app/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  task,
  search,
  starred,
  added,
  // completed
  // deleted,
  account,
  signIn,
  statistics,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/signIn') {
          return '/';
        }
      } else {
        if (path == '/account') {
          return '/';
        }
        if (path == '/statistics') {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) =>
            TaskListScreen(option: DrawerOption.allTasks),
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: TaskListScreen(option: DrawerOption.allTasks),
          );
        },
        routes: [
          GoRoute(
              path: 'task/:id',
              name: AppRoute.task.name,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final taskId = state.pathParameters['id']!;
                return DialogPage(
                    builder: (_) => EditTaskScreen(taskId: taskId));
              }
              // routes: [
              //   GoRoute(
              //     path: 'review',
              //     name: AppRoute.leaveReview.name,
              //     pageBuilder: (context, state) {
              //       final productId = state.pathParameters['id']!;
              //       return MaterialPage(
              //         fullscreenDialog: true,
              //         child: LeaveReviewScreen(productId: productId),
              //       );
              //     },
              //   ),
              // ],
              ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'statistics',
            name: AppRoute.statistics.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: StatisticsScreen(),
            ),
          ),
          GoRoute(
            path: 'added',
            name: AppRoute.added.name,
            builder: (context, state) =>
                TaskListScreen(option: DrawerOption.added),
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: TaskListScreen(option: DrawerOption.added),
            ),
          ),
          GoRoute(
            path: 'starred',
            name: AppRoute.starred.name,
            builder: (context, state) =>
                TaskListScreen(option: DrawerOption.starred),
            pageBuilder: (context, state) =>
                buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: TaskListScreen(option: DrawerOption.starred),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: AppRoute.search.name,
        builder: (context, state) =>
            TaskListScreen(option: DrawerOption.search),
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: TaskListScreen(option: DrawerOption.search),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 60),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
