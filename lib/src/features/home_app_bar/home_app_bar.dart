import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/home_app_bar/more_menu_button.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    // * This widget is responsive.
    // * On large screen sizes, it shows all the actions in the app bar.
    // * On small screen sizes, it shows only the shopping cart icon and a
    // * [MoreMenuButton].
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < Breakpoint.tablet) {
      return AppBar(
        title: Text('My To-Do app'.hardcoded),
        actions: [
          /// TODO: Search();
          MoreMenuButton(user: user),
        ],
        leading: IconButton(
          onPressed: () {
            // if (!Platform.isAndroid && !Platform.isIOS) {
            //   _controller.setExtended(true);
            // }
            Scaffold.of(context).openDrawer();
            // _key.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      );
    } else {
      return AppBar(
        title: Text('My To-Do app'.hardcoded),
        actions: [
          /// To-Do: Search();
          MoreMenuButton(user: user),
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  double get height => const HomeAppBar().preferredSize.height;
}
