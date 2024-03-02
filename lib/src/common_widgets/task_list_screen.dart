import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_scrollable_column.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:riverpod_todo_app/src/constants/app_sizes.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/add_task/add_task_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/completed/completed_tasks_screen.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/starred/starred_tasks_screen.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/all_tasks/all_tasks_screen.dart';
import 'package:riverpod_todo_app/src/features/search/presentation/search_screen.dart';
import 'package:riverpod_todo_app/src/features/home_app_bar/home_app_bar.dart';

/// Shows the list of tasks
class TaskListScreen extends ConsumerWidget {
  final DrawerOption option;
  TaskListScreen({
    Key? key,
    required this.option,
  }) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: screenWidth < Breakpoint.desktop ? const AppDrawer() : null,
      floatingActionButton: screenWidth > Breakpoint.desktop
          ? null
          : FloatingActionButton(
              foregroundColor: Theme.of(context).colorScheme.primary,
              mini: true,
              onPressed: () async {
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
              child: const Icon(Icons.add),
            ),
      body: screenWidth < Breakpoint.desktop
          ? CustomScrollView(
              slivers: [
                ResponsiveSliverColumn(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child:
                        // push to different routes based on selected option
                        switch (option) {
                      DrawerOption.search => const SearchScreen(),
                      DrawerOption.allTasks => const AllTasksScreen(),
                      DrawerOption.starredTasks => const StarredTasksScreen(),
                      DrawerOption.completed => const CompletedTasksScreen(),
                    }),
              ],
            )
          : ResponsiveTwoColumnLayout(
              startContent: CustomScrollView(
                  controller: _scrollController,
                  slivers: const [
                    ResponsiveSliverColumn(
                      padding: EdgeInsets.zero,
                      child: MyDrawer(),
                    ),
                  ]),
              spacing: Sizes.p4,
              endContent: CustomScrollView(
                slivers: [
                  ResponsiveSliverColumn(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child:
                          // push to different routes based on selected option
                          switch (option) {
                        DrawerOption.search => const SearchScreen(),
                        DrawerOption.allTasks => const AllTasksScreen(),
                        DrawerOption.starredTasks => const StarredTasksScreen(),
                        DrawerOption.completed => const CompletedTasksScreen(),
                      }),
                ],
              ),
            ),
    );
  }
}
