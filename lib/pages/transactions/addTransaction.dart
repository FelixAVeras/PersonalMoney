import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
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
      SnackHelper.showMessage(context, AppLocalizations.of(context)!.emptyCategory);
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
        title: Text(AppLocalizations.of(context)!.addTransactionTitle),
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
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.description,
                        hintText: AppLocalizations.of(context)!.descriptionHint),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.emptyDescriptionMsg;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.category,
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
                    title: Text(AppLocalizations.of(context)!.expense),
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
                    title: Text(AppLocalizations.of(context)!.income),
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
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.money),
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.amount),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.emptyAmountMsg;
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
                          SnackHelper.showMessage(context, AppLocalizations.of(context)!.transactionSaved);
                          
                          Navigator.pop(context);
                        } else {
                          SnackHelper.showMessage(context, AppLocalizations.of(context)!.errorSavingTransactionMsg);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal
                    ),
                    icon: Icon(Icons.cloud_upload_outlined),
                    label: Text(AppLocalizations.of(context)!.btnSaveChanges)
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