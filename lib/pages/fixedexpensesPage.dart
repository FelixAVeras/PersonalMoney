import 'package:flutter/material.dart';
import 'package:personalmoney/pages/addFixedExpensesPage.dart';

class FixedExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Pantalla de Gastos Fijos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddFixedExpensesPage())),
        icon: Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: Colors.teal.shade300,
        label: Text('Agregar Nueva', style: TextStyle(color: Colors.white, fontSize: 17.0)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}