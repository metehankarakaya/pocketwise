import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const SettingsItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(indent: 10, endIndent: 10, height: 0,),
        ListTile(
          dense: true,
          onTap: onTap,
          title: Text(title),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        const Divider(indent: 10, endIndent: 10, height: 0,),
      ],
    );
  }
}
