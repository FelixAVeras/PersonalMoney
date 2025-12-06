import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/TransactionModel.dart';

enum ExpenseType { income, expense }

class AddtransactionPage extends StatefulWidget {
  @override
  State<AddtransactionPage> createState() => _AddtransactionPageState();
}

class _AddtransactionPageState extends State<AddtransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  String _selectedCategoryName = "Choose a Category";

  final SQLHelper _sqlHelper = SQLHelper();

  ExpenseType? _expenseType = ExpenseType.expense;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    
    super.dispose();
  }

  Future<void> _loadCategories() async {
    List<CategoryModel> cats = await _sqlHelper.getCategories();
    setState(() {
      _categories = cats;
    });
  }

  Future<bool> _saveTransaction() async {
    if (_selectedCategoryId == null) {
      SnackHelper.showMessage(context, "You must choose a category");
      return false;
    }

    try {
      double amount = double.parse(_amountController.text);
      String description = _descriptionController.text;
      String type = _expenseType == ExpenseType.income ? 'income' : 'expense';

      TransactionModel transaction = TransactionModel(
        name: description,
        amount: amount,
        transType: type,
        date: DateTime.now().toString(),
        categoryId: _selectedCategoryId,
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
        title: Text('Add Transaction'),
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
                        labelText: 'Description',
                        hintText: 'Coffee, new shoes, etc...'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insert description.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategoryId,
                    items: _categories.map((cat) {
                      return DropdownMenuItem<int>(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    title: const Text('Expense'),
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
                    title: const Text('Income'),
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
                        labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insert a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool _success = await _saveTransaction();

                        if (_success && context.mounted) {
                          SnackHelper.showMessage(context, ' Transaction Saved');
                          
                          Navigator.pop(context);
                        } else {
                          SnackHelper.showMessage(context, 'Error saving transaction');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal
                    ),
                    icon: Icon(Icons.cloud_upload),
                    label: Text('Save Changes')
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