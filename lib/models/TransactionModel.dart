class TransactionModel {
  int id;
  int categoryId;
  double amount;
  String date;

  TransactionModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'amount': amount,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      date: map['date'],
    );
  }

  @override
  String toString() {
    return 'TransactionModel{id: $id, categoryId: $categoryId, amount: $amount, date: $date}';
  }
}
