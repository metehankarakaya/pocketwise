import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/widgets/confirmation_dialog.dart';
import 'package:pocketwise/features/settings/screens/recurring_transaction_screen.dart';
import 'package:pocketwise/features/settings/widgets/change_username_dialog.dart';
import 'package:pocketwise/features/transaction/providers/recurring_transaction_provider.dart';
import 'package:pocketwise/features/transaction/providers/transaction_provider.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(AppStrings.app.tr()),
              ),
              Card(
                child: SettingsItem(
                  onTap: () => ChangeUsernameDialog.show(context, ref),
                  title: AppStrings.changeUsername.tr(),
                ),
              ),
              Card(
                child: SettingsItem(
                  onTap: () => ChangeLanguageModal.show(context),
                  title: AppStrings.changeLanguage.tr(),
                ),
              ),
              ListTile(
                title: Text(AppStrings.transactions.tr()),
              ),
              Card(
                child: SettingsItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecurringTransactionScreen())
                    );
                  },
                  title: AppStrings.viewRecurringTransactions.tr(),
                ),
              ),
              Card(
                child: SettingsItem(
                  onTap: () => ConfirmationDialog.show(
                    context,
                    title: AppStrings.clearAllTransactionsTitle.tr(),
                    content: AppStrings.clearAllTransactionsMessage.tr(),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(transactionProvider.notifier).clearAllTransactions();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.wasCleared.tr()),
                          backgroundColor: Colors.green.shade400,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        )
                      );
                    }
                  ),
                  title: AppStrings.clearAllTransactions.tr(),
                ),
              ),
              Card(
                child: SettingsItem(
                  onTap: () => ConfirmationDialog.show(
                    context,
                    title: AppStrings.clearAllRecurringTransactionsTitle.tr(),
                    content: AppStrings.clearAllRecurringTransactionsMessage.tr(),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(recurringTransactionProvider.notifier).clearAllRecurringTransactions();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.recurringTransactionsCleared.tr()),
                          backgroundColor: Colors.green.shade400,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        )
                      );
                    }
                  ),
                  title: AppStrings.clearAllRecurringTransactions.tr(),
                ),
              ),
              ListTile(
                title: Text(AppStrings.appSecurity.tr()),
              ),
              Card(
                child: SettingsItem(
                  onTap: () {},
                  title: AppStrings.appLock.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
