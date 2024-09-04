class TransactionModel {
  int? id;
  String name;
  int? categoryId;
  double amount;
  String date;
  String transType;

  TransactionModel({
    this.id,
    required this.name,
    this.categoryId,
    required this.amount,
    required this.date,
    required this.transType
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'amount': amount,
      'type': transType,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      amount: map['amount'],
      date: map['date'], 
      transType: map['transType'],
    );
  }

  @override
  String toString() {
    return 'TransactionModel{id: $id, name: $name, categoryId: $categoryId, amount: $amount, date: $date}';
  }
}
