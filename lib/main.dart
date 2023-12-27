import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/app.dart';

void main() async {
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    runApp(const MyApp());

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    debugPrint(error.toString());
  });
}
