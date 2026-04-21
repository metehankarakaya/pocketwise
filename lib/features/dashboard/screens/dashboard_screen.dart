import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
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

    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pocket Wise"),
        actions: [
          IconButton(
            onPressed: () {},
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
                child: SizedBox(
                  width: size.width/2,
                  child: Card(
                    child: ListTile(
                      title: Text("👋 Hi! Metehan"),
                    ),
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
              const Divider(),
              SizedBox(width: double.infinity, child: Text("Son İşlemler", style: Theme.of(context).textTheme.headlineSmall,)),
              Column(
                children: transactions.map((transaction) {
                  return TransactionListItem(transactionModel: transaction);
                }).toList(),
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
