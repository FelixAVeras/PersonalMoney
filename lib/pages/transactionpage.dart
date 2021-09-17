// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:personalmoney/bloc/transactions_bloc.dart';
// import 'package:personalmoney/helpers/databasehelper.dart';
// import 'package:personalmoney/models/transactionmodel.dart';
// import 'package:personalmoney/pages/historypage.dart';

// enum TransType { earning, expense }

// class TransactionPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _TransactionPageState();
//   }
// }

// class _TransactionPageState extends State<TransactionPage> {
//   final streamTransaction = new TransactionsBloc();

//   final titleController = TextEditingController();
//   final amountController = TextEditingController();
//   String currentDatetime =
//       DateFormat("dd/MM/yyyy - hh:mm a").format(DateTime.now());
//   String transType = 'earning';
//   TransType _transType = TransType.earning;

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     titleController.dispose();
//     amountController.dispose();

//     super.dispose();
//   }

//   void _onSubmit() {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       final initDb = DatabaseHelper.db.initDB();

//       initDb.then((datab) async {
//         await DatabaseHelper.db.createTransaction(TransactionModel(
//             description: titleController.text,
//             amount: double.parse(amountController.text),
//             currentDate: currentDatetime,
//             transType: transType));
//       });

//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomPadding: false,
//         appBar: AppBar(
//           title: Text('Transacciones'),
//         ),
//         body: Form(
//           key: _formKey,
//           child: Container(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(children: <Widget>[
//                 Text(
//                   'Nueva Transacción',
//                   style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor),
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   'Todas las transacciones se guardaran con la fecha y hora actual en la que se registre.',
//                   style: TextStyle(
//                       fontSize: 16.0,
//                       fontStyle: FontStyle.italic,
//                       color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20.0),
//                 TextFormField(
//                     controller: titleController,
//                     decoration: new InputDecoration(
//                         prefixIcon: Icon(Icons.title),
//                         labelText: 'Descripción de la Transacción',
//                         border: OutlineInputBorder(),
//                         hintText: 'Descripcion del gasto o ingreso'),
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Ingrese una descripción valida';
//                       }
//                       return null;
//                     }),
//                 SizedBox(height: 20.0),
//                 Row(children: [
//                   Expanded(
//                       child: ListTile(
//                     title: Text('Ingreso'),
//                     leading: Radio(
//                         value: TransType.earning,
//                         groupValue: _transType,
//                         onChanged: (TransType value) {
//                           setState(() {
//                             _transType = value;
//                             transType = 'earning';
//                           });
//                         }),
//                   )),
//                   Expanded(
//                       child: ListTile(
//                     title: Text('Gasto'),
//                     leading: Radio(
//                         value: TransType.expense,
//                         groupValue: _transType,
//                         onChanged: (TransType value) {
//                           setState(() {
//                             _transType = value;
//                             transType = 'expense';
//                           });
//                         }),
//                   )),
//                 ]),
//                 SizedBox(height: 20.0),
//                 TextFormField(
//                     controller: amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: new InputDecoration(
//                       prefixIcon: Icon(Icons.local_atm),
//                       labelText: 'Monto de la Transacción',
//                       border: OutlineInputBorder(),
//                       hintText: 'Valores solo númericos',
//                     ),
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Monto de la Transacción es incorrecto o vacío';
//                       }
//                       return null;
//                     }),
//                 SizedBox(height: 80.0),
//                 RaisedButton(
//                   onPressed: _onSubmit,
//                   padding:
//                       EdgeInsets.symmetric(vertical: 15.0, horizontal: 105.0),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.0)),
//                   textColor: Colors.white,
//                   color: Theme.of(context).primaryColor,
//                   child: Text('Agregar Transacción'),
//                 ),
//               ]),
//             ),
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';

enum TransType { earning, expense }

class TransactionPage extends StatefulWidget {
  TransactionPage();

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  _TransactionPageState();

  DbConn dbconn = DbConn();
  final _addFormKey = GlobalKey<FormState>();
  // final format = DateFormat("dd-MM-yyyy");
  String currentDatetime =
      DateFormat("dd/MM/yyyy - hh:mm a").format(DateTime.now());
  final _transDateController = TextEditingController();
  final _transNameController = TextEditingController();
  String transType = 'earning';
  final _amountController = TextEditingController();
  TransType _transType = TransType.earning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones'),
        centerTitle: true,
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                // Container(
                //   margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                //   child: Column(
                //     children: <Widget>[
                //       Text('Transaction Date'),
                //       DateTimeField(
                //         format: format,
                //         controller: _transDateController,
                //         onShowPicker: (context, currentValue) {
                //           return showDatePicker(
                //               context: context,
                //               firstDate: DateTime(1900),
                //               initialDate: currentValue ?? DateTime.now(),
                //               lastDate: DateTime(2100));
                //         },
                //         onChanged: (value) {},
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  'Todas las transacciones se guardaran con la fecha y hora actual en la que se registre.',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600]),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _transNameController,
                        decoration: const InputDecoration(
                            hintText: 'Compra de Zapatos',
                            prefixIcon: Icon(Icons.title_rounded),
                            labelText: 'Descripcion de la Transaccion',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese una descripcion';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      Text('Tipo Transaccion'),
                      ListTile(
                        title: const Text('Ingreso'),
                        leading: Radio(
                          value: TransType.earning,
                          groupValue: _transType,
                          onChanged: (TransType value) {
                            setState(() {
                              _transType = value;
                              transType = 'earning';
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Gasto'),
                        leading: Radio(
                          value: TransType.expense,
                          groupValue: _transType,
                          onChanged: (TransType value) {
                            setState(() {
                              _transType = value;
                              transType = 'expense';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                            hintText: '284.69',
                            prefixIcon: Icon(Icons.local_atm_rounded),
                            labelText: 'Monto de la Transaccion',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese un monto valido';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                          splashColor: Colors.red,
                          onPressed: () {
                            if (_addFormKey.currentState.validate()) {
                              _addFormKey.currentState.save();
                              final initDB = dbconn.initDB();
                              initDB.then((db) async {
                                await dbconn.insertTrans(TransactionModel(
                                    currentDate: currentDatetime,
                                    description: _transNameController.text,
                                    transType: transType,
                                    amount: int.parse(_amountController.text)));
                              });

                              Navigator.pop(context);
                            }
                          },
                          child: Text('Guardar',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.teal,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 105.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
