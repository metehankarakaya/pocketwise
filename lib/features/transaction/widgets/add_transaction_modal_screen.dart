import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/widgets/add_recurring_transaction_screen.dart';
import 'package:pocketwise/features/transaction/widgets/add_transaction_screen.dart';

class AddTransactionModalScreen extends StatelessWidget {
  final TransactionModel? transactionModel;
  final RecurringTransactionModel? recurringTransactionModel;
  const AddTransactionModalScreen({super.key, this.transactionModel, this.recurringTransactionModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (transactionModel != null) {
      return AddTransactionScreen(transactionModel: transactionModel);
    } else if (recurringTransactionModel != null) {
      return AddRecurringTransactionScreen(recurringTransactionModel: recurringTransactionModel);
    } else {
      return DefaultTabController(
        length: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorScheme.primaryContainer,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: colorScheme.onPrimaryContainer,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    tabs: [
                      Tab(text: AppStrings.instantTransactionTitle.tr()),
                      Tab(text: AppStrings.recurringTransactionTitle.tr()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AddTransactionScreen(transactionModel: transactionModel,),
                    AddRecurringTransactionScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

  }
}
