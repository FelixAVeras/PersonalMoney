import 'package:flutter/material.dart';

class TransactionsFormPage extends StatefulWidget {
  @override
  _TransactionsFormPageState createState() => _TransactionsFormPageState();
}

class _TransactionsFormPageState extends State<TransactionsFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // backgroundColor: Colors.teal,
        backgroundColor: Color(0xFF78c2ad),
      ),
      body: Center(child: Text('Pantalla de TransactionsForm')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(Icons.save_alt_outlined, color: Colors.white),
        label: Text('Guardar', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF56cc9d),
        elevation: 1,
      ),
    );
  }
}