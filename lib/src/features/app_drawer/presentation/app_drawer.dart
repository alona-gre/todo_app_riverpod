import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/constants/app_sizes.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/home_app_bar/home_app_bar.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/add_task/add_task_widget.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

enum DrawerOption {
  search,
  allTasks,
  starredTasks,
  completed,
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: MyDrawer(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

// * Keys for testing using find.byKey()
  static const allTasks = Key('allTasks');
  static const starredTaskList = Key('starredTaskList');
  static const completedTaskList = Key('completedTaskList');

  @override
  Widget build(BuildContext context) {
    const appBar = HomeAppBar();
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      height: max(
          MediaQuery.of(context).size.height - appBar.preferredSize.height,
          500),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (screenWidth < Breakpoint.desktop)
              const SizedBox(height: Sizes.p48),
            if (screenWidth > Breakpoint.desktop || kIsWeb)
              ListTile(
                onTap: () async {
                  Scaffold.of(context).closeDrawer();
                  await showDialog<void>(
                      context: context,
                      builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: const AddTaskWidget(),
                              ),
                            ),
                          ));
                },
                leading: CircleAvatar(
                  maxRadius: Sizes.p12,
                  foregroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.add,
                    size: Sizes.p16,
                  ),
                ),
                title: const Text('Add task'),
              ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () async {
                if (screenWidth < Breakpoint.desktop) {
                  Scaffold.of(context).closeDrawer();
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (context.mounted) context.goNamed(AppRoute.search.name);
                } else {
                  context.goNamed(AppRoute.search.name);
                }
              },
            ),
            const Divider(
              height: 3,
            ),
            ListTile(
              key: allTasks,
              leading: const Icon(Icons.folder_special),
              title: const Text('All tasks'),
              onTap: () async {
                if (screenWidth < Breakpoint.desktop) {
                  Scaffold.of(context).closeDrawer();
                  await Future.delayed(const Duration(milliseconds: 150));
                  if (context.mounted) context.goNamed(AppRoute.home.name);
                } else {
                  context.goNamed(AppRoute.home.name);
                }
              },
            ),
            const Divider(
              height: 3,
            ),
            ListTile(
              key: starredTaskList,
              leading: const Icon(Icons.star),
              title: Text('Starred tasks'.hardcoded),
              onTap: () async {
                if (screenWidth < Breakpoint.desktop) {
                  Scaffold.of(context).closeDrawer();
                  await Future.delayed(const Duration(milliseconds: 150));
                  if (context.mounted) {
                    context.goNamed(AppRoute.starredTasks.name);
                  }
                } else {
                  context.goNamed(AppRoute.starredTasks.name);
                }
              },
            ),
            ListTile(
              key: completedTaskList,
              leading: const Icon(Icons.check),
              title: const Text('Completed tasks'),
              onTap: () async {
                if (screenWidth < Breakpoint.desktop) {
                  Scaffold.of(context).closeDrawer();
                  await Future.delayed(const Duration(milliseconds: 150));
                  if (context.mounted) {
                    context.goNamed(AppRoute.completed.name);
                  }
                } else {
                  context.goNamed(AppRoute.completed.name);
                }
              },
            ),
            const Divider(
              height: 3,
            ),
            ListTile(
              leading: const Icon(Icons.folder_special),
              title: const Text('Recently deleted'),
              // trailing: Text('${state.allTasks.length}'),
              onTap: () {},
            ),
            const Divider(
              height: 3,
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: const ExpansionTile(
                title: Text('My views'),
                leading: Icon(Icons.folder_special),
                children: <Widget>[
                  ListTile(title: Text('This is tile number 1')),
                ],
              ),
            ),
            // TODO: Dark theme switch
            //const DarkThemeSwitch(),
          ],
        ),
      ),
    );
  }
}
