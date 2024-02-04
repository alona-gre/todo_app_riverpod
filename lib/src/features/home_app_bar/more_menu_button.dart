import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

enum PopupMenuOption {
  signIn,
  statistics,
  account,
}

class MoreMenuButton extends StatelessWidget {
  final AppUser? user;
  const MoreMenuButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  static const signInKey = Key('menuSignIn');
  static const statisticsKey = Key('menuStatistics');
  static const accountKey = Key('menuAccount');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // three vertical dots icon (to reveal menu options)
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) {
        // show all the options based on conditional logic
        return <PopupMenuEntry<PopupMenuOption>>[
          if (user == null)
            PopupMenuItem(
              key: signInKey,
              value: PopupMenuOption.signIn,
              child: Text('Sign In'.hardcoded),
            ),
          if (user != null)
            PopupMenuItem(
              key: accountKey,
              value: PopupMenuOption.account,
              child: Text('Account'.hardcoded),
            ),
          PopupMenuItem(
            key: statisticsKey,
            value: PopupMenuOption.statistics,
            child: Text('Statistics'.hardcoded),
          ),
        ];
      },
      onSelected: (option) {
        // push to different routes based on selected option
        switch (option) {
          case PopupMenuOption.signIn:
            context.goNamed(AppRoute.signIn.name);
          case PopupMenuOption.statistics:
            context.goNamed(AppRoute.statistics.name);
          case PopupMenuOption.account:
            context.goNamed(AppRoute.account.name);
        }
      },
    );
  }
}
