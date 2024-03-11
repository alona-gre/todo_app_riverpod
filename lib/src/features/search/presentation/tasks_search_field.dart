import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_center.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/all_tasks/tasks_search_state_provider.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

/// Search field used to filter tasks by name
class TasksSearchTextField extends ConsumerStatefulWidget {
  const TasksSearchTextField({Key? key}) : super(key: key);

  @override
  ConsumerState<TasksSearchTextField> createState() =>
      _TasksSearchTextFieldState();
}

class _TasksSearchTextFieldState extends ConsumerState<TasksSearchTextField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // See this article for more info about how to use [ValueListenableBuilder]
    // with TextField:
    // https://codewithandrea.com/articles/flutter-text-field-form-validation/
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return ResponsiveCenter(
          maxContentWidth: screenWidth / 1.5,
          child: TextField(
            controller: _controller,
            autofocus: false,
            style: screenWidth < Breakpoint.desktop
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: 'Search tasks'.hardcoded,
              icon: const Icon(Icons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        ref.read(tasksSearchQueryStateProvider.notifier).state =
                            '';
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
            onChanged: (text) =>
                ref.read(tasksSearchQueryStateProvider.notifier).state = text,
          ),
        );
      },
    );
  }
}
