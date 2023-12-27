import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/constants/breakpoints.dart';

class ResponsiveColumn extends StatelessWidget {
  const ResponsiveColumn({
    super.key,
    this.maxContentWidth = Breakpoint.tablet,
    this.padding = EdgeInsets.zero,
    required this.child,
  });
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxContentWidth,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
    // );
  }
}

/// Sliver-equivalent of [ResponsiveColumn].
class ResponsiveSliverColumn extends StatelessWidget {
  const ResponsiveSliverColumn({
    super.key,
    this.maxContentWidth = Breakpoint.tablet,
    this.padding = EdgeInsets.zero,
    required this.child,
  });
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ResponsiveColumn(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
