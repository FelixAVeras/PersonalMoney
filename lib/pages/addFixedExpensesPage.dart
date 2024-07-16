import 'package:flutter/material.dart';

class AddFixedExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Gastos Fijos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: const Center(child: Text('Pantalla de Gastos Fijos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: Colors.teal.shade300,
        tooltip: 'Agregar Nueva',
      ),
    );
  }
}