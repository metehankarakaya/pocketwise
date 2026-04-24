import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/widgets/recurring_transaction_list_item.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_list_item.dart';

import '../../../core/widgets/empty_holder.dart';

class TransactionSearchDelegate extends SearchDelegate<dynamic> {
  final List<TransactionModel> transactions;
  final List<RecurringTransactionModel> recurringTransactions;

  TransactionSearchDelegate(this.transactions, this.recurringTransactions);

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
    if (query.isEmpty) {
      return EmptyHolder(iconData: Icons.search, title: AppStrings.search.tr());
    }
    final filteredTransactions = transactions.where((t) => t.title.toLowerCase().contains(query.toLowerCase()) || t.category.toLowerCase().contains(query.toLowerCase())).toList();
    final filteredRecurringTransactions = recurringTransactions.where((r) => r.title.toLowerCase().contains(query.toLowerCase()) || r.category.toLowerCase().contains(query.toLowerCase())).toList();
    if (filteredTransactions.isEmpty && filteredRecurringTransactions.isEmpty) {
      return EmptyHolder(iconData: Icons.search_off, title: AppStrings.noResultsForQuery.tr(
        namedArgs: {"query": query}
      ));
    } else {
      return ListView(
        children: [
          ...filteredTransactions.map((element) => Card(
            clipBehavior: Clip.antiAlias,
            child: TransactionListItem(transactionModel: element))
          ),
          ...filteredRecurringTransactions.map((element) => Card(
              clipBehavior: Clip.antiAlias,
            child: RecurringTransactionListItem(recurringTransaction: element))
          )
        ],
      );
    }
  }

}
