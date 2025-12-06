import 'package:intl/intl.dart';

class FormatHelper {
  String formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US', 
      symbol: '\$', 
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    
    return formatter.format(parsedDate);
  }
}