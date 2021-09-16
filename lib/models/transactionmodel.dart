// class TransactionModel {
//   int id;
//   String description;
//   double amount;
//   String currentDate;
//   String transType;

//   TransactionModel(
//       {this.id,
//       this.description,
//       this.amount,
//       this.currentDate,
//       this.transType});

//   factory TransactionModel.fromJson(Map<String, dynamic> json) =>
//       TransactionModel(
//           id: json["id"],
//           description: json["description"],
//           currentDate: json["currentDate"],
//           amount: json["amount"],
//           transType: json["transType"]);

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "description": description,
//         "currentDate": currentDate,
//         "amount": amount,
//         "type": transType
//       };
// }

class TransactionModel {
  final int id;
  final String currentDate;
  final String description;
  final String transType;
  final int amount;

  TransactionModel(
      {this.id,
      this.currentDate,
      this.description,
      this.transType,
      this.amount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': currentDate,
      'name': description,
      'type': transType,
      'amount': amount
    };
  }

  @override
  String toString() {
    return 'Trans{id: $id, transName: $description, amount: $amount}';
  }
}
