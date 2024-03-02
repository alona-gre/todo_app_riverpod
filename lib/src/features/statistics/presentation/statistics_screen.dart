import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

/// Shows statistics for the tasks
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
      appBar: AppBar(title: Text('Statistics'.hardcoded)),
      body: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text('Statistics of completing tasks'),
          ),
        ],
      ),
    );

    // CustomScrollView(
    //   controller: _scrollController,
    //   slivers: const [
    //     ResponsiveSliverCenter(
    //       padding: EdgeInsets.all(Sizes.p16),
    //       child: StatisticsScreen(),
    //     ),
    //     ResponsiveSliverCenter(
    //       padding: EdgeInsets.all(Sizes.p16),
    //       child: AllTasksListScreen(),
    //     ),
    //   ],
    // ),
  }
}
