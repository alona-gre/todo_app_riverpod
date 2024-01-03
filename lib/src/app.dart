import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      routerConfig: goRouter,
      onGenerateTitle: (BuildContext context) => 'My To-Do app'.hardcoded,
      theme: ThemeData(
        visualDensity: const VisualDensity(),
        primarySwatch: Colors.grey,
        primaryColor: const Color.fromARGB(66, 192, 188, 188),
        // cardColor is used by ExpansionPanelList
        // cardColor: Color.fromARGB(255, 245, 243, 243),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
    );
  }
}
