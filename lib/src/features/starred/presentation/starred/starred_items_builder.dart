import 'package:flutter/material.dart';

import 'package:riverpod_todo_app/src/common_widgets/empty_placeholder_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/responsive_center.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

/// Responsive widget showing the cart items and the checkout button
class StarredItemsBuilder extends StatelessWidget {
  const StarredItemsBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
  });
  final List<StarredItem> items;
  final Widget Function(BuildContext, StarredItem, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    // If there are no items, show a placeholder
    if (items.isEmpty) {
      return EmptyPlaceholderWidget(
        message: 'Your starred is empty'.hardcoded,
      );
    }
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    // * on wide layouts, show a list of items on the left and the checkout
    // * button on the right
    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = items[index];
              return itemBuilder(context, item, index);
            },
            itemCount: items.length,
          ),
        ),
      );
    } else {
      // * on narrow layouts, show a [Column] with a scrollable list of items
      // * and a pinned box at the bottom with the checkout button
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = items[index];
                return itemBuilder(context, item, index);
              },
              itemCount: items.length,
            ),
          ),
        ],
      );
    }
  }
}
