import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/models/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/historypage.dart';

class CurrencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyPageState();
  }
}

class _CurrencyPageState extends State<CurrencyPage> {
  final streamTransaction = new TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Personal Money'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Text(
              'Convertidor de Divisas',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            TransactionForm(),
            OutlineButton(
              onPressed: () {
                // if (_formKey.currentState.validate()) {
                //   // Process data.
                // }
                doConvertion();
              },
              textColor: Theme.of(context).primaryColor,
              child: Text('Convertir'),
            ),
          ]),
        ),
      ),
    );
  }

  doConvertion() async {}
}

class TransactionForm extends StatefulWidget {
  TransactionForm({Key key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final descriptionField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: TextFormField(
              decoration: new InputDecoration(
                  labelText: 'Descripción de la Transacción',
                  border: OutlineInputBorder(),
                  hintText: 'Descripcion del gasto o ingreso'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese una descripción valida';
                }
                return null;
              },
              controller: descriptionField,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                labelText: 'Monto de la Transacción',
                border: OutlineInputBorder(),
                hintText: 'Valores solo númericos',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Monto de la Transacción es incorrecto o vacío';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
