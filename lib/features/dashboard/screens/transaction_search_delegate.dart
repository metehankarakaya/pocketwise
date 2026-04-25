import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/features/transaction/screens/add_transaction_modal.dart';
import 'package:pocketwise/features/transaction/widgets/recurring_transaction_list_item.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_list_item.dart';

import '../../../core/widgets/empty_holder.dart';
import '../../transaction/providers/recurring_transaction_provider.dart';
import '../../transaction/providers/transaction_provider.dart';

class TransactionSearchDelegate extends SearchDelegate<dynamic> {
  final WidgetRef ref;
  TransactionSearchDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = "",
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final transactions = ref.read(transactionProvider);
    final recurringTransactions = ref.read(recurringTransactionProvider);
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: EmptyHolder(iconData: Icons.search, title: AppStrings.searchEmptyState.tr())
        ),
      );
    }
    final filteredTransactions = transactions.where((t) => t.title.toLowerCase().contains(query.toLowerCase()) || t.category.toLowerCase().contains(query.toLowerCase())).toList();
    final filteredRecurringTransactions = recurringTransactions.where((r) => r.title.toLowerCase().contains(query.toLowerCase()) || r.category.tr().toLowerCase().contains(query.toLowerCase())).toList();
    if (filteredTransactions.isEmpty && filteredRecurringTransactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: EmptyHolder(iconData: Icons.search_off, title: AppStrings.noResultsForQuery.tr(
            namedArgs: {"query": query}
          )),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ...filteredTransactions.map((element) => Card(
              clipBehavior: Clip.antiAlias,
              child: Dismissible(
                key: Key(element.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => ref.read(transactionProvider.notifier).removeTransaction(element.id),
                child: TransactionListItem(
                  onLongPress: () => AddTransactionModal.show(context, transactionModel: element),
                  transactionModel: element
                ),
              ))
            ),
            ...filteredRecurringTransactions.map((element) => Card(
              clipBehavior: Clip.antiAlias,
              child: Dismissible(
                key: Key(element.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => ref.read(recurringTransactionProvider.notifier).removeRecurring(element.id),
                child: RecurringTransactionListItem(
                  onLongPress: () => AddTransactionModal.show(context, recurringTransactionModel: element),
                  recurringTransaction: element
                ),
              ))
            )
          ],
        ),
      );
    }
  }

}
