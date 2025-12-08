// models/monthly_balance_model.dart
class MonthlyBalanceModel {
  final int? id;
  final double initialBalance;
  final double spent;
  final int month;
  final int year;

  MonthlyBalanceModel({
    this.id,
    required this.initialBalance,
    this.spent = 0,
    required this.month,
    required this.year,
  });

  double get left => initialBalance - spent;

  factory MonthlyBalanceModel.fromMap(Map<String, dynamic> map) {
    return MonthlyBalanceModel(
      id: map['id'] as int?,
      initialBalance: (map['initial_balance'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      month: map['month'] as int,
      year: map['year'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'initial_balance': initialBalance,
      'spent': spent,
      'month': month,
      'year': year,
    };
  }

  MonthlyBalanceModel copyWith({
    int? id,
    double? initialBalance,
    double? spent,
    int? month,
    int? year,
  }) {
    return MonthlyBalanceModel(
      id: id ?? this.id,
      initialBalance: initialBalance ?? this.initialBalance,
      spent: spent ?? this.spent,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
