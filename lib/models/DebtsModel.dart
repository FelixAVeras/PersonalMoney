class DebtModel {
  final int? id;
  final String description;
  final double totalAmount;
  final String createdAt;
  final int isSettled; // 0 o 1

  DebtModel({this.id, required this.description, required this.totalAmount, required this.createdAt, this.isSettled = 0});

  Map<String, dynamic> toMap() => {
    'id': id,
    'description': description,
    'total_amount': totalAmount,
    'created_at': createdAt,
    'is_settled': isSettled,
  };

  factory DebtModel.fromMap(Map<String, dynamic> map) => DebtModel(
    id: map['id'],
    description: map['description'],
    totalAmount: map['total_amount'],
    createdAt: map['created_at'],
    isSettled: map['is_settled'],
  );
}