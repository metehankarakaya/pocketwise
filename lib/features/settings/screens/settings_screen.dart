import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/theme_provider.dart';
import '../widgets/change_language_modal.dart';
import '../widgets/settings_item.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settingsTitle.tr()),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              themeMode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            SettingsItem(
              onTap: () => ChangeLanguageModal.show(context),
              title: AppStrings.changeLanguage.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
