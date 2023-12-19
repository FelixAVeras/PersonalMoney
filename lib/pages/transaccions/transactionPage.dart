import 'package:flutter/material.dart';
import 'package:personalmoney/pages/transaccions/trasactionFormPage.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Pantalla de Transactions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionsFormPage()));
        },
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: Color(0xFF78c2ad),
        elevation: 1,
      ),
    );
  }
}