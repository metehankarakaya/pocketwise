import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/core/providers/user_provider.dart';
import 'package:pocketwise/core/widgets/empty_holder.dart';
import 'package:pocketwise/features/dashboard/providers/dashboard_provider.dart';
import 'package:pocketwise/features/dashboard/screens/transaction_search_delegate.dart';
import 'package:pocketwise/features/settings/screens/settings_screen.dart';
import 'package:pocketwise/features/transaction/screens/add_transaction_modal.dart';
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final filteredTransactions = activeFilter == null
        ? transactions
        : transactions.where((t) {
      switch (activeFilter) {
        case DateFilter.today:
          return !t.createdAt.isBefore(today);
        case DateFilter.week:
          final weekAgo = now.subtract(const Duration(days: 7));
          return t.createdAt.isAfter(weekAgo);
        case DateFilter.month:
          final monthAgo = DateTime(now.year, now.month - 1, now.day);
          return t.createdAt.isAfter(monthAgo);
        case DateFilter.year:
          final yearAgo = DateTime(now.year - 1, now.month, now.day);
          return t.createdAt.isAfter(yearAgo);
        }
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Card(
                child: ListTile(
                  title: Text("${AppStrings.homeGreeting.tr()} $username"),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
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
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
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
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(AppStrings.recentTransactions.tr(), style: Theme.of(context).textTheme.headlineSmall,),
                    IconButton(
                      onPressed: () => showSearch(
                        context: context,
                        delegate: TransactionSearchDelegate(ref)
                      ),
                      icon: Icon(Icons.search),
                    )
                  ],
                )
              ),
            ),
            if (filteredTransactions.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = filteredTransactions[index];
                    return Dismissible(
                      key: Key(transaction.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => ref.read(transactionProvider.notifier).removeTransaction(transaction.id),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: TransactionListItem(
                          onLongPress: () => AddTransactionModal.show(context, transactionModel: transaction),
                          transactionModel: transaction,
                        ),
                      ),
                    );
                  },
                  childCount: filteredTransactions.length
                ),
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    child: EmptyHolder(
                      iconData: activeFilter != null ? Icons.search_off : Icons.receipt_long,
                      title: activeFilter != null ? "${AppStrings.noTransactionsInPeriod.tr()} (${activeFilter.name.tr()})" : AppStrings.noTransactionsYet.tr(),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTransactionModal.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
