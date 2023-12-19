import 'package:flutter/material.dart';
import 'package:personalmoney/pages/transaccions/trasactionFormPage.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final List<Map<String, dynamic>> _allTransactions = [
    {"id": 1, "description": "Pago de la factura del celular", "amount": 795.00},
    {"id": 2, "description": "Ganancia de venta de ropa", "amount": 4000.00},
    {"id": 3, "description": "Venta por E-Commerse", "amount": 47.99},
    {"id": 4, "description": "Pago de Renta", "amount": 25000.00}
  ];

  List<Map<String, dynamic>> _transactions = [];

  @override
  initState() {
    _transactions = _allTransactions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_transactions[index]["id"]),
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('\$${_transactions[index]["amount"].toString()}'),
                    subtitle: Text(_transactions[index]['description']),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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