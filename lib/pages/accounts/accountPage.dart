import 'package:flutter/material.dart';
import 'package:personalmoney/pages/transaccions/trasactionFormPage.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Pantalla de Cuentas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: Color(0xFF78c2ad),
        elevation: 1,
      ),
    );
  }
}