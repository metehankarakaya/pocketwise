import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/providers/recurring_transaction_provider.dart';

class RecurringTransactionListItem extends ConsumerWidget {
  final RecurringTransactionModel recurringTransaction;
  final VoidCallback onLongPress;
  const RecurringTransactionListItem({super.key, required this.recurringTransaction, required this.onLongPress});

  static IconData _iconForCategory(String category) {
    switch (category) {
      case AppStrings.food: return Icons.fastfood;
      case AppStrings.groceries: return Icons.shopping_cart;
      case AppStrings.transport: return Icons.directions_car;
      case AppStrings.bills: return Icons.receipt_long;
      case AppStrings.entertainment: return Icons.movie;
      case AppStrings.health: return Icons.local_hospital;
      case AppStrings.education: return Icons.school;
      case AppStrings.clothing: return Icons.checkroom;
      case AppStrings.technology: return Icons.devices;
      case AppStrings.subscription: return Icons.subscriptions;
      default: return Icons.category;
    }
  }

  static Color _colorForCategory(String category) {
    switch (category) {
      case AppStrings.food: return Colors.orange;
      case AppStrings.groceries: return Colors.blue;
      case AppStrings.transport: return Colors.purple;
      case AppStrings.bills: return Colors.red;
      case AppStrings.entertainment: return Colors.pink;
      case AppStrings.health: return Colors.teal;
      case AppStrings.education: return Colors.indigo;
      case AppStrings.clothing: return Colors.brown;
      case AppStrings.technology: return Colors.cyan;
      case AppStrings.subscription: return Colors.deepPurple;
      default: return Colors.grey;
    }
  }

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formatDateRange(DateTime startDate, DateTime? endDate) {
      final dateFormat = DateFormat('dd MMMM yyyy', context.locale.toString());
      final start = dateFormat.format(startDate);
      if (endDate == null) {
        return "$start - ∞";
      }
      return "$start - ${dateFormat.format(endDate)}";
    }

    final colorScheme = Theme.of(context).colorScheme;
    final formattedAmount = formatter.format(recurringTransaction.amount);

    final bool isExpense = recurringTransaction.type == TransactionType.expense;
    final categoryColor = _colorForCategory(recurringTransaction.category);

    final Color amountColor = isExpense
      ? Colors.redAccent.shade400
      : const Color(0xFF10B981);

    return Opacity(
      opacity: recurringTransaction.isActive ? 1.0 : 0.6,
      child: ListTile(
        onLongPress: onLongPress,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _iconForCategory(recurringTransaction.category),
            color: categoryColor,
            size: 24,
          ),
        ),
        title: Text(
          "${recurringTransaction.title} (${recurringTransaction.frequency.name.tr()})",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          formatDateRange(recurringTransaction.startDate, recurringTransaction.endDate),
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: .end,
          children: [
            Text(
              "${isExpense ? "-" : "+"}$formattedAmount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: amountColor,
                decoration: recurringTransaction.isActive ? null : TextDecoration.lineThrough,
              ),
            ),
            SizedBox(
              height: 30,
              width: 45,
              child: Transform.scale(
                scale: 0.7,
                child: Switch(
                  onChanged: (_) => ref.read(recurringTransactionProvider.notifier).toggleIsActive(recurringTransaction.id),
                  value: recurringTransaction.isActive,
                  activeThumbColor: const Color(0xFF10B981),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
