// lib/models/expense.dart
class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final int categoryId;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['categoryId'],
    );
  }
}
