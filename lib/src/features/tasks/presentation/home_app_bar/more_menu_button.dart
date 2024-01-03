import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  orders,
  account,
}

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({
    Key? key,
  }) : super(key: key);

  static const signInKey = Key('menuSignIn');
  static const ordersKey = Key('menuOrders');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return <PopupMenuEntry<PopupMenuOption>>[
          PopupMenuItem(
            key: ordersKey,
            value: PopupMenuOption.orders,
            child: Text('Orders'.hardcoded),
          ),
          PopupMenuItem(
            key: accountKey,
            value: PopupMenuOption.account,
            child: Text('Account'.hardcoded),
          ),
        ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signIn:
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     fullscreenDialog: true,
            //     builder: (_) => const EmailPasswordSignInScreen(
            //       formType: EmailPasswordSignInFormType.signIn,
            //     ),
            //   ),
            // );
            break;
          case PopupMenuOption.orders:
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     fullscreenDialog: true,
            //     builder: (_) => const OrdersListScreen(),
            //   ),
            // );
            break;
          case PopupMenuOption.account:
            context.goNamed(AppRoute.account.name);
            break;
        }
      },
    );
  }
}
