class TransactionModel {
  TransactionModel({
    this.id,
    this.description,
    this.currentDate,
    this.moneyExpend,
    this.savingMoney,
  });

  int id;
  String description;
  String currentDate;
  double moneyExpend;
  double savingMoney;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        description: json["description"],
        currentDate: json["currentDate"],
        moneyExpend: json["moneyExpend"].toDouble(),
        savingMoney: json["savingMoney"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "currentDate": currentDate,
        "moneyExpend": moneyExpend,
        "savingMoney": savingMoney,
      };
}
