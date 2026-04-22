import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/transaction_model.dart';

import '../providers/dashboard_provider.dart';

class TransactionSummaryCard extends ConsumerWidget {
  final TransactionType type;
  final double amount;

  const TransactionSummaryCard({super.key, required this.type, required this.amount});

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    final formattedAmount = formatter.format(amount);
    final isIncome = type == TransactionType.income;

    final icon = isIncome
      ? Icons.arrow_upward_outlined
      : Icons.arrow_downward_outlined;

    final title = isIncome
      ? AppStrings.transactionIncome.tr()
      : AppStrings.transactionExpense.tr();

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 32,
            ),
          ),
        ),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(title),
            Text(
              dashboard
              ? "₺******"
              : formattedAmount
            ),
          ],
        )
      ],
    );
  }
}
