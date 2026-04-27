import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../transaction/providers/transaction_provider.dart';

class ChangeLanguageModal {

  static void show(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              await context.setLocale(const Locale("tr"));
              final notifier = ref.read(transactionProvider.notifier);
              NotificationService().showBalanceNotification(
                notifier.totalBalance,
                notifier.totalIncome,
                notifier.totalExpense,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            title: Text("🇹🇷 Türkçe"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () async {
              await context.setLocale(const Locale("en", "US"));
              final notifier = ref.read(transactionProvider.notifier);
              NotificationService().showBalanceNotification(
                notifier.totalBalance,
                notifier.totalIncome,
                notifier.totalExpense,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            title: Text("🇺🇸 English"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () async {
              await context.setLocale(const Locale("de"));
              final notifier = ref.read(transactionProvider.notifier);
              NotificationService().showBalanceNotification(
                notifier.totalBalance,
                notifier.totalIncome,
                notifier.totalExpense,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            title: Text("🇩🇪 Deutsch"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () async {
              await context.setLocale(const Locale("es"));
              final notifier = ref.read(transactionProvider.notifier);
              NotificationService().showBalanceNotification(
                notifier.totalBalance,
                notifier.totalIncome,
                notifier.totalExpense,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            title: Text("🇪🇸 Español"),
          ),
        ],
      ),
    );
  }

}
