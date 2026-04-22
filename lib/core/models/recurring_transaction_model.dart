import 'package:pocketwise/core/models/transaction_model.dart';

enum RecurringFrequency {daily, weekly, monthly, yearly}

class RecurringTransactionModel {

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime lastProcessDate;
  final DateTime startDate;
  final DateTime? endDate;
  final RecurringFrequency frequency;
  final TransactionType type;
  bool isActive;

  RecurringTransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.lastProcessDate,
    required this.startDate,
    this.endDate,
    required this.frequency,
    required this.type,
    required this.isActive
  });

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) => RecurringTransactionModel(
    id: json["id"].toString(),
    title: json["title"],
    amount: (json["amount"] as num).toDouble(),
    category: json["category"],
    lastProcessDate: DateTime.parse(json["lastProcessDate"] as String),
    startDate: DateTime.parse(json["startDate"] as String),
    endDate: json["endDate"] != null ? DateTime.parse(json["endDate"] as String) : null,
    frequency: RecurringFrequency.values.byName(json["frequency"] as String),
    type: TransactionType.values.byName(json["type"] as String),
    isActive: json["isActive"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "amount": amount,
    "category": category,
    "lastProcessDate": lastProcessDate.toIso8601String(),
    "startDate": startDate.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "frequency": frequency.name,
    "type": type.name,
    "isActive": isActive
  };

  RecurringTransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? lastProcessDate,
    DateTime? startDate,
    DateTime? endDate,
    RecurringFrequency? frequency,
    TransactionType? type,
    bool? isActive
  }) {
    return RecurringTransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      lastProcessDate: lastProcessDate ?? this.lastProcessDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      frequency: frequency ?? this.frequency,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive
    );
  }

}
