import 'package:flutter/material.dart';

class OverviewHelper {
  Color getBalanceColor(double amount, double spent) {
    double balance = amount - spent;

    if (balance < 0) return Colors.red; // negativo = rojo

    double percentLeft = balance / amount;

    if (percentLeft <= 0.10) return Colors.red;     // < 10%
    if (percentLeft <= 0.20) return Colors.orange;  // < 20%

    return Colors.green; // normal
  }
}