import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/models/recurring_transaction_model.dart';
import 'package:pocketwise/core/models/transaction_model.dart';
import 'package:pocketwise/features/transaction/providers/transaction_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RecurringTransactionProvider extends Notifier<List<RecurringTransactionModel>> {
  @override
  List<RecurringTransactionModel> build() {
    // TODO: implement build
    _loadRecurringTransactions();
    return [];
  }

  late SharedPreferences _prefs;

  void _processRecurringTransactions() async {
    for (var recurring in state) {
      int periodsElapsed = 0;
      final daysDiff = DateTime.now().difference(recurring.lastProcessDate).inDays;
      if (recurring.isActive) {
        if (recurring.endDate != null && DateTime.now().isAfter(recurring.endDate!)) {
          continue;
        }
        switch (recurring.frequency) {
          case RecurringFrequency.daily:
            periodsElapsed = daysDiff;
          break;
          case RecurringFrequency.weekly:
            periodsElapsed = daysDiff~/7;
          break;
          case RecurringFrequency.monthly:
            periodsElapsed = daysDiff~/30;
          break;
          case RecurringFrequency.yearly:
            periodsElapsed = daysDiff~/365;
          break;
        }
        if (periodsElapsed > 0) {
          for (int i=0; i<periodsElapsed; i++) {
            ref.read(transactionProvider.notifier).addTransaction(
              recurring.title,
              recurring.amount,
              recurring.category,
              recurring.lastProcessDate.add(Duration(days: i+1)),
              recurring.type
            );
          }
        }
        state = state.map((element) {
          if (element.id == recurring.id) {
            return element.copyWith(lastProcessDate: DateTime.now());
          }
          return element;
        }).toList();
      }
    }
    _prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(state.map((r) => r.toJson()).toList());
    await _prefs.setString("recurring_transactions", encodedData);
  }

  void _loadRecurringTransactions() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedData = _prefs.getString("recurring_transactions");
    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);
      state = decodedData.map((element) => RecurringTransactionModel.fromJson((element))).toList();
      state.sort((a, b) => b.startDate.compareTo(a.startDate));
    }
    _processRecurringTransactions();
  }

  void addRecurring({
    required String title,
    required double amount,
    required String category,
    required DateTime startDate,
    required RecurringFrequency frequency,
    required TransactionType type,
    required bool isActive,
    DateTime? endDate,
  }) async {
    RecurringTransactionModel recurringTransactionModel = RecurringTransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      lastProcessDate: startDate,
      startDate: startDate,
      endDate: endDate,
      frequency: frequency,
      type: type,
      isActive: isActive
    );
    _prefs = await SharedPreferences.getInstance();
    state = [recurringTransactionModel, ...state];
    state.sort((a, b) => b.startDate.compareTo(a.startDate));
    final String encodedData = jsonEncode(state.map((recurringTransaction) => recurringTransaction.toJson()).toList());
    await _prefs.setString("recurring_transactions", encodedData);
  }

  void removeRecurring(String id) async {
    state = state.where((element) => element.id != id).toList();
    final String encodedData = jsonEncode(state.map((recurringTransaction) => recurringTransaction.toJson()).toList());
    await _prefs.setString("recurring_transactions", encodedData);
  }

  void clearAllRecurringTransactions() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("recurring_transactions");
  }

  void toggleIsActive(String id) async {
    state = state.map((element) {
      if (element.id == id) {
        return element.copyWith(isActive: !element.isActive);
      }
      return element;
    }).toList();
    state.sort((a, b) => b.startDate.compareTo(a.startDate));
    final String encodedData = jsonEncode(state.map((recurringTransaction) => recurringTransaction.toJson()).toList());
    await _prefs.setString("recurring_transactions", encodedData);
  }

  void updateRecurring(String id, String title, double amount, String category, DateTime startDate, RecurringFrequency frequency, TransactionType type, {DateTime? endDate}) async {
    state = state.map((recurring) {
      if (recurring.id == id) {
        return recurring.copyWith(
          title: title,
          amount: amount,
          category: category,
          startDate: startDate,
          frequency: frequency,
          type: type,
          endDate: endDate
        );
      }
      return recurring;
    }).toList();
    state.sort((a, b) => b.startDate.compareTo(a.startDate));
    final String encodedData = jsonEncode(state.map((transaction) => transaction.toJson()).toList());
    await _prefs.setString("recurring_transactions", encodedData);
  }

}

final recurringTransactionProvider = NotifierProvider<RecurringTransactionProvider, List<RecurringTransactionModel>>(RecurringTransactionProvider.new);
