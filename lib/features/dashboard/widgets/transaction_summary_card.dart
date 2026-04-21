import 'package:flutter/material.dart';
import 'package:pocketwise/core/models/transaction_model.dart';

class TransactionSummaryCard extends StatelessWidget {
  final TransactionType type;
  final double amount;

  const TransactionSummaryCard({super.key, required this.type, required this.amount});

  @override
  Widget build(BuildContext context) {
    final isIncome = type == TransactionType.income;

    final icon = isIncome
      ? Icons.arrow_upward_outlined
      : Icons.arrow_downward_outlined;

    final title = isIncome
      ? "Gelir"
      : "Gider";

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
            Text("₺${amount.toStringAsFixed(2)}"),
          ],
        )
      ],
    );
  }
}
