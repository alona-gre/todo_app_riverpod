import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_scrollable_column.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:riverpod_todo_app/src/constants/app_sizes.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/search/presentation/search_screen.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/home_app_bar/home_app_bar.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/all_tasks_list.dart';

/// Shows the list of products with a search field at the top.
class TaskListScreen extends StatelessWidget {
  final DrawerOption option;
  TaskListScreen({
    Key? key,
    required this.option,
  }) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: screenWidth < Breakpoint.desktop ? const AppDrawer() : null,
      body: screenWidth < Breakpoint.desktop
          ? CustomScrollView(
              slivers: [
                ResponsiveSliverColumn(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child:
                        // push to different routes based on selected option
                        switch (option) {
                      DrawerOption.allTasks => const AllTasksList(),
                      DrawerOption.search => const SearchScreen(),
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
                        DrawerOption.allTasks => const AllTasksList(),
                        DrawerOption.search => const SearchScreen(),
                      }),
                ],
              ),
            ),
    );
  }
}
