import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const SettingsItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: onTap,
          title: Text(title),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
