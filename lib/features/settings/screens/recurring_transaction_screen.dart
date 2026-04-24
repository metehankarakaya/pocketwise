import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/features/transaction/providers/recurring_transaction_provider.dart';
import 'package:pocketwise/features/transaction/widgets/recurring_transaction_list_item.dart';

import '../../../core/widgets/empty_holder.dart';
import '../../transaction/widgets/add_transaction_modal.dart';

class RecurringTransactionScreen extends ConsumerWidget {
  const RecurringTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringTransactions = ref.watch(recurringTransactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.recurringTransactions.tr()),
      ),
      body: recurringTransactions.isNotEmpty
      ? Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: recurringTransactions.map((element) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Dismissible(
                  key: Key(element.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(recurringTransactionProvider.notifier).removeRecurring(element.id),
                  child: RecurringTransactionListItem(
                  onLongPress: () => AddTransactionModal.show(context, recurringTransactionModel: element),
                  recurringTransaction: element,
                  ),
                )
              );
            }).toList(),
          ),
        ),
      ) : EmptyHolder(
        title: AppStrings.noRecurringTransactions.tr(),
        iconData: Icons.receipt_long,
      ),
    );
  }
}
