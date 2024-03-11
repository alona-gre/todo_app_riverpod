import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkThemeSwitch extends StatelessWidget {
  const DarkThemeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return SwitchListTile(
          title: const Row(
            children: [
              Icon(Icons.nights_stay),
              SizedBox(
                width: 14,
              ),
              Text('Dark Theme'),
            ],
          ),

          value: false,
          // state.switchValue,
          onChanged: (newValue) {
            // newValue
            // ? ref.read(provider).event)
            // : ref.read(provider).event);
          },
        );
      },
    );
  }
}
