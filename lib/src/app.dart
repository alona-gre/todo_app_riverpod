import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      routerConfig: goRouter,
      onGenerateTitle: (BuildContext context) => 'My To-Do app'.hardcoded,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: const VisualDensity(),

        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            background: Colors.white,
            onBackground: const Color.fromARGB(66, 192, 188, 188),
            error: Colors.red,
            onTertiary: Colors.orange),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 6, 92, 8),
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),

        // cardColor is used by ExpansionPanelList
        // cardColor: Color.fromARGB(255, 245, 243, 243),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
