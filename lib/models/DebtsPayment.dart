class DebtPaymentModel {
  final int? id;
  final int debtId;
  final double amount;
  final String paymentDate;

  DebtPaymentModel({this.id, required this.debtId, required this.amount, required this.paymentDate});

  Map<String, dynamic> toMap() => {
    'id': id,
    'debt_id': debtId,
    'amount': amount,
    'payment_date': paymentDate,
  };
}