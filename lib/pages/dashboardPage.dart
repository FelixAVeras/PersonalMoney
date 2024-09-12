import 'package:flutter/material.dart';
import 'package:personalmoney/pages/budgetPage.dart';
import 'package:personalmoney/pages/transactionPage.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage())), 
              child: const Text('Ir a Presupuestos')
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage())), 
              child: const Text('Ir a Transacciones')
            )
          ],
        ),
      ),
    );
  }
}