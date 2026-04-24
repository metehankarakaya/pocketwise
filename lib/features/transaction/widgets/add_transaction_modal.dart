import 'package:flutter/material.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/widgets/add_transaction_modal_screen.dart';

class AddTransactionModal {
  static void show(BuildContext context, {TransactionModel? transactionModel}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTransactionModalScreen(transactionModel: transactionModel,)
    );
  }
}
