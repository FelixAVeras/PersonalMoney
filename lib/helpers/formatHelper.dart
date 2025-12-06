import 'package:flutter/material.dart';
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

  IconData getCategoryIcon(String name) {
    switch (name) {
      case 'Home':
        return Icons.home;
      case 'Entertainment':
        return Icons.movie;
      case 'Food':
        return Icons.restaurant;
      case 'Charity':
        return Icons.volunteer_activism;
      case 'Utilities':
        return Icons.lightbulb;
      case 'Auto':
        return Icons.directions_car;
      case 'Education':
        return Icons.school;
      case 'Health & Wellness':
        return Icons.health_and_safety;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Others':
      default:
        return Icons.question_mark;
    }
  }
}