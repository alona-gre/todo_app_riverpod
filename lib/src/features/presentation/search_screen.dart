import 'package:flutter/material.dart';

/// Shows the list of products with a search field at the top.
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text('Search tasks'),
        ),
      ],
    );

    // CustomScrollView(
    //   controller: _scrollController,
    //   slivers: const [
    //     ResponsiveSliverCenter(
    //       padding: EdgeInsets.all(Sizes.p16),
    //       child: SearchScreen(),
    //     ),
    //     ResponsiveSliverCenter(
    //       padding: EdgeInsets.all(Sizes.p16),
    //       child: AllTasksListScreen(),
    //     ),
    //   ],
    // ),
  }
}
