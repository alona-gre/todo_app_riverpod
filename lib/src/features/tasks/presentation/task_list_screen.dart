import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_scrollable_column.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:riverpod_todo_app/src/constants/app_sizes.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/search/presentation/search_screen.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/home_app_bar/home_app_bar.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/all_tasks_list.dart';

/// Shows the list of products with a search field at the top.
class TaskListScreen extends StatefulWidget {
  final DrawerOption option;
  const TaskListScreen({
    Key? key,
    required this.option,
  }) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // * Use a [ScrollController] to register a listener that dismisses the
  // * on-screen keyboard when the user scrolls.
  // * This is needed because this page has a search field that the user can
  // * type into.
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_dismissOnScreenKeyboard);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_dismissOnScreenKeyboard);
    super.dispose();
  }

  // When the search text field gets the focus, the keyboard appears on mobile.
  // This method is used to dismiss the keyboard when the user scrolls.
  void _dismissOnScreenKeyboard() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: Platform.isIOS || Platform.isAndroid ? const AppDrawer() : null,
      body: Platform.isIOS || Platform.isAndroid
          ? const AllTasksList()
          : ResponsiveTwoColumnLayout(
              startContent: CustomScrollView(
                  controller: _scrollController,
                  slivers: const [
                    ResponsiveSliverColumn(
                      padding: EdgeInsets.zero,
                      child: MyDrawer(),
                    ),
                  ]),
              spacing: Sizes.p16,
              endContent: CustomScrollView(
                slivers: [
                  ResponsiveSliverColumn(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child:
                          // push to different routes based on selected option
                          switch (widget.option) {
                        DrawerOption.allTasks => const AllTasksList(),
                        DrawerOption.search => const SearchScreen(),
                      }),
                ],
              ),
            ),
    );
  }
}
