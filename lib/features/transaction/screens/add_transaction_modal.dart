import 'package:flutter/material.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/screens/add_transaction_modal_screen.dart';

class AddTransactionModal {
  static void show(BuildContext context, {TransactionModel? transactionModel, RecurringTransactionModel? recurringTransactionModel}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTransactionModalScreen(transactionModel: transactionModel, recurringTransactionModel: recurringTransactionModel,)
    );
  }
}
