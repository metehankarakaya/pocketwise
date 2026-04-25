import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool enabled;
  const SettingsItem({super.key, required this.title, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        children: [
          ListTile(
            dense: true,
            onTap: enabled ? onTap : null,
            title: Text(title),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
    );
  }
}
