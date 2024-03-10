import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/app.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:riverpod_todo_app/src/exceptions/async_error_logger.dart';
import 'package:riverpod_todo_app/src/exceptions/error_logger.dart';
import 'package:riverpod_todo_app/src/features/sync_service/sync_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/sembast_tasks_repository.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

void main() async {
  // https://docs.flutter.dev/testing/errors

  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors

  final localTasksRepository = await SembastTasksRepository.makeDefault();
  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    overrides: [
      localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
    ],
    observers: [AsyncErrorLogger()],
  );
  // * Initialize SyncService to star the listener
  container.read(syncServiceProvider);
  final errorLogger = container.read(errorLoggerProvider);
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers(errorLogger);
  // * Entry point of the app
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
