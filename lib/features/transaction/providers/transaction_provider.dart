import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider extends Notifier<List<TransactionModel>>{
  @override
  List<TransactionModel> build() {
    // TODO: implement build
    _loadTransactions();
    return [];
  }

  late SharedPreferences _prefs;

  void _loadTransactions() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedData = _prefs.getString("transactions");
    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);
      state = decodedData.map((element) => TransactionModel.fromJson((element))).toList();
    }
  }

  void addTransaction(TransactionModel transaction) async {
    state = [... state, transaction];
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("transactions", encodedData);
  }

  void removeTransaction(String id) async {
    state = state.where((element) => element.id != id).toList();
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("transactions", encodedData);
  }

  void clearAllTransactions() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("transactions");
  }

}

final transactionProvider = NotifierProvider<TransactionProvider, List<TransactionModel>>(() => TransactionProvider());
