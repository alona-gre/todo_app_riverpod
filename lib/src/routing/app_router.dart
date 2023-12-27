import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list_screen.dart';
import 'package:riverpod_todo_app/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  task,
  search,
  // product,
  // leaveReview,
  // cart,
  // wishlist,
  // checkout,
  // orders,
  // account,
  // signIn,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  //final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      // final isLoggedIn = authRepository.currentUser != null;
      // final path = state.uri.path;
      // if (isLoggedIn) {
      //   if (path == '/signIn') {
      //     return '/';
      //   }
      // } else {
      //   if (path == '/account' || path == '/orders') {
      //     return '/';
      //   }
      // }
      return null;
    },
    // refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) =>
            const TaskListScreen(option: DrawerOption.allTasks),
        routes: [
          GoRoute(
            path: 'search',
            name: AppRoute.search.name,
            builder: (context, state) =>
                const TaskListScreen(option: DrawerOption.search),
            // pageBuilder: (context, state) {
            //   return const MaterialPage(
            //     fullscreenDialog: true,
            //     child: SearchScreen(),
            //   );
            // },
          ),
          // GoRoute(
          //   path: 'task/:id',
          //   name: AppRoute.task.name,
          //   builder: (context, state) {
          //     final taskId = state.pathParameters['id']!;
          //     return TaskScreen(productId: productId);
          //   },
          //   routes: [
          //     GoRoute(
          //       path: 'review',
          //       name: AppRoute.leaveReview.name,
          //       pageBuilder: (context, state) {
          //         final productId = state.pathParameters['id']!;
          //         return MaterialPage(
          //           fullscreenDialog: true,
          //           child: LeaveReviewScreen(productId: productId),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // GoRoute(
          //   path: 'cart',
          //   name: AppRoute.cart.name,
          //   pageBuilder: (context, state) => const MaterialPage(
          //     fullscreenDialog: true,
          //     child: ShoppingCartScreen(),
          //   ),
          //   routes: [
          //     GoRoute(
          //       path: 'checkout',
          //       name: AppRoute.checkout.name,
          //       pageBuilder: (context, state) => const MaterialPage(
          //         fullscreenDialog: true,
          //         child: CheckoutScreen(),
          //       ),
          //     ),
          //   ],
          // ),
          // GoRoute(
          //   path: 'wishlist',
          //   name: AppRoute.wishlist.name,
          //   pageBuilder: (context, state) => const MaterialPage(
          //     fullscreenDialog: true,
          //     child: WishlistScreen(),
          //   ),
          // ),
          // GoRoute(
          //   path: 'orders',
          //   name: AppRoute.orders.name,
          //   pageBuilder: (context, state) => const MaterialPage(
          //     fullscreenDialog: true,
          //     child: OrdersListScreen(),
          //   ),
          // ),
          // GoRoute(
          //   path: 'account',
          //   name: AppRoute.account.name,
          //   pageBuilder: (context, state) => const MaterialPage(
          //     fullscreenDialog: true,
          //     child: AccountScreen(),
          //   ),
          // ),
          // GoRoute(
          //   path: 'signIn',
          //   name: AppRoute.signIn.name,
          //   pageBuilder: (context, state) => const MaterialPage(
          //     fullscreenDialog: true,
          //     child: EmailPasswordSignInScreen(
          //       formType: EmailPasswordSignInFormType.signIn,
          //     ),
          //   ),
          // ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
