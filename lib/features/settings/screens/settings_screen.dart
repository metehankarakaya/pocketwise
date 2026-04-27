import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/providers/notification_provider.dart';
import 'package:pocketwise/core/widgets/confirmation_dialog.dart';
import 'package:pocketwise/features/security/providers/security_provider.dart';
import 'package:pocketwise/features/security/screens/pin_screen.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final themeMode = ref.watch(themeModeProvider);
    final isLockEnabled = ref.watch(securityProvider);
    final isNotificationEnabled = ref.watch(notificationProvider);

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
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    title: Text(AppStrings.app.tr()),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () => ChangeUsernameDialog.show(context, ref),
                      title: AppStrings.changeUsername.tr(),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () => ChangeLanguageModal.show(context, ref),
                      title: AppStrings.changeLanguage.tr(),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    title: Text(AppStrings.transactions.tr()),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
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
                    clipBehavior: Clip.antiAlias,
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
                              content: Text(
                                AppStrings.wasCleared.tr(),
                                style: TextStyle(color: colorScheme.onPrimaryContainer),
                              ),
                              backgroundColor: colorScheme.primaryContainer,
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
                    clipBehavior: Clip.antiAlias,
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
                              content: Text(
                                AppStrings.recurringTransactionsCleared.tr(),
                                style: TextStyle(color: colorScheme.onPrimaryContainer),
                              ),
                              backgroundColor: colorScheme.primaryContainer,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            )
                          );
                        }
                      ),
                      title: AppStrings.clearAllRecurringTransactions.tr(),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    title: Text(AppStrings.notifications.tr()),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () {
                        final notifier = ref.read(transactionProvider.notifier);
                        ref.read(notificationProvider.notifier).toggleNotification(
                          notifier.totalBalance,
                          notifier.totalIncome,
                          notifier.totalExpense,
                        );
                      },
                      title: isNotificationEnabled ? AppStrings.hidePersistentNotification.tr() : AppStrings.showPersistentNotification.tr(),
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ListTile(
                    trailing: Tooltip(
                      showDuration: Duration(seconds: 2),
                      message: AppStrings.pinForgotWarning.tr(),
                      child: Icon(Icons.info_outline),
                    ),
                    title: Text(AppStrings.appSecurity.tr()),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen())),
                      enabled: !isLockEnabled,
                      title: AppStrings.enableAppLock.tr(),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(mode: PinMode.disable))),
                      enabled: isLockEnabled,
                      title: AppStrings.disableAppLock.tr(),
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: SettingsItem(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(mode: PinMode.change))),
                      enabled: isLockEnabled,
                      title: AppStrings.changeAppLock.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
