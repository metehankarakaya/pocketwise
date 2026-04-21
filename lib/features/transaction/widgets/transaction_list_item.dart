import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketwise/core/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transactionModel;
  const TransactionListItem({super.key, required this.transactionModel});

  static IconData _iconForCategory(String category) {
    switch (category) {
      case "Gıda": return Icons.fastfood;
      case "Market": return Icons.shopping_cart;
      case "Ulaşım": return Icons.directions_car;
      case "Fatura": return Icons.receipt_long;
      case "Eğlence": return Icons.movie;
      case "Sağlık": return Icons.local_hospital;
      case "Eğitim": return Icons.school;
      case "Giyim": return Icons.checkroom;
      case "Teknoloji": return Icons.devices;
      case "Abonelik": return Icons.subscriptions;
      default: return Icons.category;
    }
  }

  static Color _colorForCategory(String category) {
    switch (category) {
      case "Gıda": return Colors.orange;
      case "Market": return Colors.blue;
      case "Ulaşım": return Colors.purple;
      case "Fatura": return Colors.red;
      case "Eğlence": return Colors.pink;
      case "Sağlık": return Colors.teal;
      case "Eğitim": return Colors.indigo;
      case "Giyim": return Colors.brown;
      case "Teknoloji": return Colors.cyan;
      case "Abonelik": return Colors.deepPurple;
      default: return Colors.grey;
    }
  }

  static final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
  static final timeFormat = DateFormat.Hm('tr_TR');

  @override
  Widget build(BuildContext context) {
    final formattedAmount = formatter.format(transactionModel.amount);

    final formattedTime = timeFormat.format(transactionModel.createdAt);

    final bool isExpense = transactionModel.type == TransactionType.expense;
    final categoryColor = _colorForCategory(transactionModel.category);

    return ListTile(
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
          color: isExpense ? Colors.redAccent.shade400 : const Color(0xFF10B981),
        ),
      ),
      title: Text(
        transactionModel.title.isEmpty ? transactionModel.category : transactionModel.title
      ),
      subtitle: Text(formattedTime),
    );
  }
}
