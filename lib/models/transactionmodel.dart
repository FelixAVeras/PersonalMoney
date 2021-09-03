class TransactionModel {
  int id;
  String description;
  double amount;
  String currentDate;
  // DateTime currentDate;
  // double moneyExpend;
  // double savingMoney;

  // int get txnId => id;
  // String get txnTitle => description;
  // double get txnAmount => amount;
  // DateTime get txnDateTime => currentDate;

  TransactionModel({
    this.id,
    this.description,
    this.amount,
    this.currentDate,
    // this.moneyExpend,
    // this.savingMoney,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
          id: json["id"],
          description: json["description"],
          currentDate: json["currentDate"],
          amount: json["amount"]
          // moneyExpend: json["moneyExpend"].toDouble(),
          // savingMoney: json["savingMoney"].toDouble(),
          );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "currentDate": currentDate,
        "amount": amount
        // "moneyExpend": moneyExpend,
        // "savingMoney": savingMoney,
      };
}
