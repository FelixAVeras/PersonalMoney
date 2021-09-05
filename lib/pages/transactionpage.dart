import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/dashboradpage.dart';
import 'package:personalmoney/pages/historypage.dart';

class TransactionPage extends StatefulWidget {
  // final Function _addTransaction;

  // TransactionPage(this._addTransaction);

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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();

    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      // final txtdescription = titleController.text;
      // final txtamount = double.parse(amountController.text);
      // final txtcurrentDate = currentDatetime;

      // widget._addTransaction(txtdescription, txtamount, txtcurrentDate);
      _formKey.currentState.save();
      final initDb = DatabaseHelper.db.initDB();

      initDb.then((datab) async {
        await DatabaseHelper.db.createTransaction(TransactionModel(
            description: titleController.text,
            amount: double.parse(amountController.text),
            currentDate: currentDatetime));
      });

      Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => DashboardPage()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Transacciones'),
          centerTitle: true,
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

// class TransactionForm extends StatefulWidget {
//   TransactionForm({Key key}) : super(key: key);

//   @override
//   _TransactionFormState createState() => _TransactionFormState();
// }

// class _TransactionFormState extends State<TransactionForm> {
//   final _formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 25.0),
//             child: TextFormField(
//                 controller: titleController,
//                 decoration: new InputDecoration(
//                     prefixIcon: Icon(Icons.title),
//                     labelText: 'Descripción de la Transacción',
//                     border: OutlineInputBorder(),
//                     hintText: 'Descripcion del gasto o ingreso'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Ingrese una descripción valida';
//                   }
//                   return null;
//                 }),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 25.0),
//             child: TextFormField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: new InputDecoration(
//                   prefixIcon: Icon(Icons.local_atm),
//                   labelText: 'Monto de la Transacción',
//                   border: OutlineInputBorder(),
//                   hintText: 'Valores solo númericos',
//                 ),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Monto de la Transacción es incorrecto o vacío';
//                   }
//                   return null;
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
