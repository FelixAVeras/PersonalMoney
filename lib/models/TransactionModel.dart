// class TransactionModel {
//   final int? id;
//   final String name;
//   final String? date;
//   final String transType;
//   final double amount;
//   final int? categoryId;
//   final String? categoryName; // ← nuevo

//   TransactionModel({
//     this.id,
//     required this.name,
//     required this.amount,
//     required this.transType,
//     this.date,
//     this.categoryId,
//     this.categoryName,
//   });

//   factory TransactionModel.fromMap(Map<String, dynamic> map) {
//     return TransactionModel(
//       id: map['id'],
//       name: map['name'],
//       amount: (map['amount'] as num).toDouble(),       // ← FIX
//       transType: map['type'] ?? map['transType'],       // ← FIX
//       date: map['date'],
//       categoryId: map['category_id'] ?? map['categoryId'], // ← FIX
//       categoryName: map['category_name'], 
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'amount': amount,               // double OK
//       'type': transType,              // Asegúrate que la columna se llama "type"
//       'date': date,
//       'category_id': categoryId,      // O "categoryId" según tu tabla
//     };
//   }

// }

// models/transaction_model.dart
class TransactionModel {
  final int? id;
  final String name;
  final String? date;
  final String transType; // 'income' | 'expense'
  final double amount;
  final int? categoryId;
  final int? month;
  final int? year;
  final String? categoryName;

  TransactionModel({
    this.id,
    required this.name,
    required this.amount,
    required this.transType,
    this.date,
    this.categoryId,
    this.month,
    this.year,
    this.categoryName,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      transType: (map['type'] ?? map['transType']) as String,
      date: map['date'] as String?,
      categoryId: map['category_id'] as int?,
      month: map['month'] as int?,
      year: map['year'] as int?,
      categoryName: map['category_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': transType,
      'date': date,
      'category_id': categoryId,
      'month': month,
      'year': year,
    };
  }
}
