enum TransactionType {income, expense}

class TransactionModel {

  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime createdAt;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.createdAt,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json["id"].toString(),
    title: json["title"],
    amount: (json["amount"] as num).toDouble(),
    category: json["category"],
    createdAt: DateTime.parse(json["createdAt"] as String),
    type: TransactionType.values.byName(json["type"] as String)
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "amount": amount,
    "category": category,
    "createdAt": createdAt.toIso8601String(),
    "type": type.name,
  };

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? createdAt,
    TransactionType? type,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type
    );
  }

}
