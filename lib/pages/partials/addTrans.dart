import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';

enum TransType { earning, expense }

class AddDataWidget extends StatefulWidget {
  AddDataWidget();

  @override
  _AddDataWidgetState createState() => _AddDataWidgetState();
}

class _AddDataWidgetState extends State<AddDataWidget> {
  _AddDataWidgetState();

  SQLHelper dbconn = SQLHelper();
  final _addFormKey = GlobalKey<FormState>();
  final format = DateFormat("dd-MM-yyyy");
  final _transNameController = TextEditingController();
  String transType = 'earning';
  final _amountController = TextEditingController();
  TransType _transType = TransType.earning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Nueva Transaccion', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white)
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: 440,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    // child: Column(
                    //   children: <Widget>[
                    //     Text('Transaction Date'),
                    //     DateTimeField(
                    //       format: format,
                    //       controller: _transDateController,
                    //       onShowPicker: (context, currentValue) {
                    //         return showDatePicker(
                    //             context: context,
                    //             firstDate: DateTime(1900),
                    //             initialDate: currentValue ?? DateTime.now(),
                    //             lastDate: DateTime(2100));
                    //       },
                    //       onChanged: (value) {},
                    //     ),
                    //   ],
                    // ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _transNameController,
                          decoration: const InputDecoration(
                            hintText: 'Ej: Compra de Zapatos',
                            label: Text('Descripcion')
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese un nombre para la transaccion.';
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
                        Text('Tipo de Transaccion'),
                        ListTile(
                          title: const Text('Ganancia'),
                          leading: Radio(
                            value: TransType.earning,
                            groupValue: _transType,
                            onChanged: (TransType? value) {
                              setState(() {
                                _transType = value!;
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
                            onChanged: (TransType? value) {
                              setState(() {
                                _transType = value!;
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
                            label: Text('Monto')
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingrese un monto.';
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
                        ElevatedButton(
                          onPressed: () async {
                            if (_addFormKey.currentState!.validate()) {
                              _addFormKey.currentState!.save();
                              
                              await dbconn.initDB();

                              final now = DateTime.now();
                              final formattedDate = DateFormat('dd/MM/yyyy').format(now);

                              await dbconn.insertTransaction(TransactionModel(
                                // date: _transDateController.text,
                                date: formattedDate,
                                name: _transNameController.text,
                                transType: transType,
                                amount: double.parse(_amountController.text),
                              ));
                              
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Guardar', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ],
              )
          )
          ),
        ),
      ),
    );
  }
}