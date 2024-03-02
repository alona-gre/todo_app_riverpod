import 'package:flutter/material.dart';

class StarredButton extends StatelessWidget {
  const StarredButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
    required this.isStarred,
  });

  final bool isLoading;
  final bool isStarred;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const addToStarredButtonKey = Key('addToStarredButton');
  static const removeFromStarredButtonKey = Key('removeFromStarredButton');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: isStarred
                    ? const Icon(
                        key: removeFromStarredButtonKey,
                        Icons.star,
                        color: Colors.amber,
                      )
                    : const Icon(
                        key: addToStarredButtonKey, Icons.star_border_outlined),
                onPressed: onPressed,
              ));
  }
}
