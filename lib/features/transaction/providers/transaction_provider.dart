import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/notification_provider.dart';
import '../../../core/services/notification_service.dart';

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
      state.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    _updateNotification();
  }

  void addTransaction(String title, double amount, String category, DateTime createdAt, TransactionType type) async {
    TransactionModel transactionModel = TransactionModel(id: const Uuid().v4(), title: title, amount: amount, category: category, createdAt: createdAt, type: type);
    state = [transactionModel, ... state];
    state.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("transactions", encodedData);
    _updateNotification();
  }

  void removeTransaction(String id) async {
    state = state.where((element) => element.id != id).toList();
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("transactions", encodedData);
    _updateNotification();
  }

  void clearAllTransactions() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("transactions");
    _updateNotification();
  }

  double get totalIncome {
    return state.where((t) => t.type == TransactionType.income).fold(
      0.0,
      (sum, t) => sum+t.amount
    );
  }

  double get totalExpense {
    return state.where((t) => t.type == TransactionType.expense).fold(
      0.0,
      (sum, t) => sum+t.amount
    );
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  void _updateNotification() {
    final isEnabled = ref.read(notificationProvider);
    if (isEnabled) {
      NotificationService().showBalanceNotification(totalBalance, totalIncome, totalExpense);
    } else {
      NotificationService().cancelNotification();
    }
  }

  void updateTransaction(String id, String title, double amount, String category, TransactionType type) async {
    state = state.map((transaction) {
      if (transaction.id == id) {
        return transaction.copyWith(title: title, amount: amount, category: category, type: type);
      }
      return transaction;
    }).toList();
    state.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("transactions", encodedData);
    _updateNotification();
  }

}

final transactionProvider = NotifierProvider<TransactionProvider, List<TransactionModel>>(() => TransactionProvider());
