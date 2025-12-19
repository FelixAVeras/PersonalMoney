import 'package:flutter/material.dart';

class OverviewHelper {
  Color getBalanceColor(double amount, double spent) {
    double balance = amount - spent;

    if (balance < 0) return Color(0xFFFF7851); // negativo = rojo

    double percentLeft = balance / amount;

    if (percentLeft <= 0.10) return Color(0xFFFF7851);     // < 10%
    if (percentLeft <= 0.20) return Color(0xFFFFCE67);  // < 20%

    return Colors.green; // normal
  }
}