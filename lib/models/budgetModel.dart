// models/budget_model.dart
class BudgetModel {
  final int? id;
  final int categoryId;
  final double amount;
  final double spent;
  final int month;
  final int year;

  BudgetModel({
    this.id,
    required this.categoryId,
    required this.amount,
    this.spent = 0,
    required this.month,
    required this.year,
  });

  double get balance => amount - spent;

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int?,
      categoryId: map['category_id'] as int,
      amount: (map['amount'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      month: map['month'] as int,
      year: map['year'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'amount': amount,
      'spent': spent,
      'month': month,
      'year': year,
    };
  }

  BudgetModel copyWith({
    int? id,
    int? categoryId,
    double? amount,
    double? spent,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
