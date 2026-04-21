import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              themeMode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode
            ),
          )
        ],
      ),
    );
  }
}
