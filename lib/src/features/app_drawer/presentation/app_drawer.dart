import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/features/add_task/presentation/add_task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/home_app_bar/home_app_bar.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list_screen.dart';

enum DrawerOption {
  allTasks,
  search,
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: MyDrawer(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const appBar = HomeAppBar();
    return Container(
      color: Theme.of(context).primaryColor,
      height: max(
          MediaQuery.of(context).size.height - appBar.preferredSize.height,
          500),
      child: Column(
        children: [
          ListTile(
            onTap: () async {
              await showDialog<void>(
                  context: context,
                  builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: const AddTask(),
                          ),
                        ),
                      ));
            },
            leading: const CircleAvatar(
              maxRadius: 12,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 15,
              ),
            ),
            title: const Text('Add task'),
          ),

          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            // onTap: () => context.goNamed(AppRoute.search.name),
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const TaskListScreen(option: DrawerOption.search),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.folder_special),
            title: const Text('All tasks'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const TaskListScreen(option: DrawerOption.allTasks),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            // trailing: Text('${state.allTasks.length}'),
          ),

          const Divider(
            height: 3,
          ),
          ListTile(
            leading: const Icon(Icons.folder_special),
            title: const Text('Completed'),
            // trailing: Text('${state.allTasks.length}'),
            onTap: () {},
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
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: const ExpansionTile(
              title: Text('My views'),
              leading: Icon(Icons.folder_special),
              children: <Widget>[
                ListTile(title: Text('This is tile number 1')),
              ],
            ),
          ),

          /// ToDo: Dark theme switch
          // BlocBuilder<SwitchBloc, SwitchState>(
          //   builder: (context, state) {
          //     return Switch(
          //       value: state.switchValue,
          //       onChanged: (newValue) {
          //         newValue
          //             ? context.read<SwitchBloc>().add(SwitchOnEvent())
          //             : context.read<SwitchBloc>().add(SwitchOffEvent());
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
