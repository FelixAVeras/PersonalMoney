import 'package:flutter/material.dart';

class DetailTransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Detalle Transaccion', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}