import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/core/providers/user_provider.dart';
import 'package:pocketwise/core/widgets/empty_holder.dart';
import 'package:pocketwise/features/dashboard/providers/dashboard_provider.dart';
import 'package:pocketwise/features/settings/screens/settings_screen.dart';
import 'package:pocketwise/features/transaction/widgets/add_transaction_modal.dart';
import 'package:pocketwise/features/transaction/widgets/transaction_list_item.dart';
import 'package:pocketwise/features/dashboard/widgets/transaction_summary_card.dart';
import 'package:pocketwise/features/dashboard/widgets/total_balance.dart';
import 'package:pocketwise/features/dashboard/widgets/total_balance_title.dart';
import 'package:pocketwise/features/transaction/providers/transaction_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final notifier = ref.watch(transactionProvider.notifier);
    final transactions = ref.watch(transactionProvider);
    final activeFilter = ref.watch(dashboardFilterProvider);
    final username = ref.watch(userProvider);

    List<DateFilter> dateFilters = [
      DateFilter.today,
      DateFilter.week,
      DateFilter.month,
      DateFilter.year
    ];

    final filteredTransactions = activeFilter == null
        ? transactions
        : transactions.where((t) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final transactionDay = DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      final diff = today.difference(transactionDay).inDays;
      if (activeFilter == DateFilter.today) {
        return diff == 0;
      } else if (activeFilter == DateFilter.week) {
        return diff <= 7;
      } else if (activeFilter == DateFilter.month) {
        return diff <= 30;
      } else if (activeFilter == DateFilter.year) {
        return diff <= 365;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName.tr()),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen())
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  child: ListTile(
                    title: Text("${AppStrings.homeGreeting.tr()} $username"),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: TotalBalanceTitle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: TotalBalance(balance: notifier.totalBalance),
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.income, amount: notifier.totalIncome,),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 16.0),
                        child: TransactionSummaryCard(type: TransactionType.expense, amount: notifier.totalExpense,),
                      )
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dateFilters.map((dateFilter) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        showCheckmark: false,
                          onSelected: (val) {
                            if (activeFilter == dateFilter) {
                              ref.read(dashboardFilterProvider.notifier).clearFilter();
                            } else {
                              ref.read(dashboardFilterProvider.notifier).setFilter(dateFilter);
                            }
                          },
                        label: Text(dateFilter.name.tr()),
                        selected: activeFilter == dateFilter,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: double.infinity, child: Text(AppStrings.recentTransactions.tr(), style: Theme.of(context).textTheme.headlineSmall,)),
              filteredTransactions.isNotEmpty
              ? Column(
                children: filteredTransactions.map((transaction) {
                  return Dismissible(
                    key: Key(transaction.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => ref.read(transactionProvider.notifier).removeTransaction(transaction.id),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: TransactionListItem(
                      onLongPress: () => AddTransactionModal.show(context, transactionModel: transaction),
                      transactionModel: transaction
                      )
                    )
                  );
                }).toList(),
              )
              : Card(
                child: EmptyHolder(
                  iconData: activeFilter != null ? Icons.search_off : Icons.receipt_long,
                  title: activeFilter != null ? "${AppStrings.noTransactionsInPeriod.tr()} (${activeFilter.name.tr()})" : AppStrings.noTransactionsYet.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTransactionModal.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
