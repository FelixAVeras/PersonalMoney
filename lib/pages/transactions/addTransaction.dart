import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/home_page.dart';

enum ExpenseType { income, expense }

class AddtransactionPage extends StatefulWidget {
  @override
  State<AddtransactionPage> createState() => _AddtransactionPageState();
}

class _AddtransactionPageState extends State<AddtransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final SQLHelper _sqlHelper = SQLHelper();

  ExpenseType? _expenseType = ExpenseType.expense;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    
    super.dispose();
  }

  Future<bool> _saveTransaction() async {
    try {
      double amount = double.parse(_amountController.text);
      String description = _descriptionController.text;
      String type = _expenseType == ExpenseType.income ? 'income' : 'expense';

      TransactionModel transaction = TransactionModel(
        name: description,
        amount: amount,
        transType: type,
        date: DateTime.now().toString(), // Fecha actual
      );

      await _sqlHelper.insertTransaction(transaction);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Agregar Transaccion', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
               key: _formKey,
               child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                        labelText: 'Descripcion',
                        hintText: 'Compra de Zapatos'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduzca una descripcion.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    title: const Text('Gasto'),
                    leading: Radio<ExpenseType>(
                      activeColor: Colors.red,
                      value: ExpenseType.expense,
                      groupValue: _expenseType,
                      onChanged: (ExpenseType? value) {
                        setState(() {
                          _expenseType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Ingreso'),
                    leading: Radio<ExpenseType>(
                      activeColor: Colors.teal,
                      value: ExpenseType.income,
                      groupValue: _expenseType,
                      onChanged: (ExpenseType? value) {
                        setState(() {
                          _expenseType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.money),
                        border: OutlineInputBorder(),
                        labelText: 'Monto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduzca un monto valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool _success = await _saveTransaction();

                        if (_success && context.mounted) {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => HomePage()),
                          // );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transacción guardada'))
                          );

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al guardar la transacción'))
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal
                    ),
                    child: Text('Guardar')
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}