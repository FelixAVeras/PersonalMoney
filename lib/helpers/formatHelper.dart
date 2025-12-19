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
    // final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateFormat formatter = DateFormat('MMMM d, y');
    
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

  double? parseAmount(String input) {
    String s = input.trim();

    // Caso: "7953" o "7953.62" -> OK (inglés)
    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(s)) {
      return double.tryParse(s);
    }

    // Caso: "7,953.62" (miles US) -> eliminar coma
    if (RegExp(r'^\d{1,3}(,\d{3})*(\.\d+)?$').hasMatch(s)) {
      s = s.replaceAll(',', '');
      return double.tryParse(s);
    }

    // Caso: "7.953,62" (formato europeo)
    if (RegExp(r'^\d{1,3}(\.\d{3})*(,\d+)?$').hasMatch(s)) {
      s = s.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(s);
    }

    // Caso simple: "7953,62" → decimal con coma
    if (s.contains(',') && !s.contains('.')) {
      s = s.replaceAll(',', '.');
      return double.tryParse(s);
    }

    return null;
  }
}