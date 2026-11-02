class Expense {
  final int? id;
  final String name;
  final String category;
  final DateTime date;
  final double amount;

  const Expense({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      amount: (map['amount'] as num).toDouble(),
    );
  }
}