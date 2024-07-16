class ImprevistoModel {
  final int? id;
  final String description;
  final double amount;
  final String date;

  ImprevistoModel({
    this.id, 
    required this.description, 
    required this.amount, 
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }
}