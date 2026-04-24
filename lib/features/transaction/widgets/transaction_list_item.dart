import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transactionModel;
  final VoidCallback? onLongPress;
  const TransactionListItem({super.key, required this.transactionModel, this.onLongPress});

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

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDay = DateTime(date.year, date.month, date.day);

    final diff = today.difference(transactionDay).inDays;

    if (diff == 0) {
      return DateFormat.Hm("tr_TR").format(date);
    } else if (diff < 7) {
      return DateFormat("EEEE HH:mm", "tr_TR").format(date);
    } else {
      return DateFormat("d MMM HH:mm", "tr_TR").format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedAmount = formatter.format(transactionModel.amount);

    final bool isExpense = transactionModel.type == TransactionType.expense;
    final categoryColor = _colorForCategory(transactionModel.category);

    final Color amountColor = isExpense
      ? Colors.redAccent.shade400
      : const Color(0xFF10B981);

    return ListTile(
      onLongPress: onLongPress,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _iconForCategory(transactionModel.category),
          color: categoryColor,
          size: 24,
        ),
      ),
      trailing: Text(
        "${isExpense ? "-" : "+"}$formattedAmount",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: amountColor,
        ),
      ),
      title: Text(
        transactionModel.title.trim().isEmpty ? transactionModel.category.tr() : transactionModel.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        _formatDate(transactionModel.createdAt),
        style: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
