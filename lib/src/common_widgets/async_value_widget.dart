import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, stackTrace) => Center(
        child: ErrorMessageWidget(
          error.toString(),
        ),
      ),
      loading: () => const Center(
        heightFactor: 10,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
