import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';

enum TransType { earning, expense }

class TransactionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<TransactionPage> {
  final streamTransaction = new TransactionsBloc();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String currentDatetime =
      DateFormat("dd/MM/yyyy - hh:mm").format(DateTime.now());
  String transType = 'earning';
  TransType _transType = TransType.earning;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();

    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final initDb = DatabaseHelper.db.initDB();

      initDb.then((datab) async {
        await DatabaseHelper.db.createTransaction(TransactionModel(
            description: titleController.text,
            amount: double.parse(amountController.text),
            currentDate: currentDatetime,
            transType: transType));
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Transacciones'),
          // centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Text(
                  'Nueva Transacción',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Todas las transacciones se guardaran con la fecha y hora actual en la que se registre.',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: titleController,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: 'Descripción de la Transacción',
                        border: OutlineInputBorder(),
                        hintText: 'Descripcion del gasto o ingreso'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese una descripción valida';
                      }
                      return null;
                    }),
                SizedBox(height: 20.0),
                Row(children: [
                  Expanded(
                      child: ListTile(
                    title: Text('Ingreso'),
                    leading: Radio(
                        value: TransType.earning,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'earning';
                          });
                        }),
                  )),
                  Expanded(
                      child: ListTile(
                    title: Text('Gasto'),
                    leading: Radio(
                        value: TransType.expense,
                        groupValue: _transType,
                        onChanged: (TransType value) {
                          setState(() {
                            _transType = value;
                            transType = 'expense';
                          });
                        }),
                  )),
                ]),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.local_atm),
                      labelText: 'Monto de la Transacción',
                      border: OutlineInputBorder(),
                      hintText: 'Valores solo númericos',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Monto de la Transacción es incorrecto o vacío';
                      }
                      return null;
                    }),
                SizedBox(height: 80.0),
                RaisedButton(
                  onPressed: _onSubmit,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 105.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: Text('Agregar Transacción'),
                ),
              ]),
            ),
          ),
        ));
  }
}
