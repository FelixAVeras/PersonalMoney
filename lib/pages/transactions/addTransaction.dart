import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';

enum ExpenseType { income, expense }

class AddtransactionPage extends StatefulWidget {
  @override
  State<AddtransactionPage> createState() => _AddtransactionPageState();
}

class _AddtransactionPageState extends State<AddtransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;
  ExpenseType _expenseType = ExpenseType.expense;

  final SQLHelper sqlHelper = SQLHelper();
  final BudgetService budgetService = BudgetService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await sqlHelper.getCategories();

    if (!mounted) return;
    setState(() => _categories = cats);
  }

  Future<bool> _saveTransaction() async {
    if (_selectedCategoryId == null) {
      SnackHelper.showMessage(
        context,
        AppLocalizations.of(context)!.emptyCategory,
      );
      return false;
    }

    try {
      final description = _descriptionController.text.trim();

      // Manejar separadores decimales
      final rawAmount =
          _amountController.text.replaceAll(".", "").replaceAll(",", ".");
      final amount = double.tryParse(rawAmount);

      if (amount == null || amount <= 0) throw Exception("Monto inválido");

      final now = DateTime.now();

      final transaction = TransactionModel(
        name: description,
        amount: amount,
        transType: _expenseType == ExpenseType.expense ? "expense" : "income",
        date: now.toIso8601String(),
        categoryId: _selectedCategoryId,
        month: now.month,
        year: now.year,
      );

      await sqlHelper.insertTransaction(transaction);

      if (transaction.transType == "expense") {
        await budgetService.subtractFromCategory(
          transaction.categoryId!,
          transaction.amount,
        );
      }

      return true;
    } catch (e, st) {
      debugPrint("ERROR AL GUARDAR TRANSACCIÓN: $e");
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addTransactionTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await _saveTransaction();
                final msg = success
                    ? AppLocalizations.of(context)!.transactionSaved
                    : AppLocalizations.of(context)!.errorSavingTransactionMsg;

                if (context.mounted) {
                  SnackHelper.showMessage(context, msg);
                  if (success) Navigator.pop(context, true);
                }
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.description,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? AppLocalizations.of(context)!.emptyDescriptionMsg : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.category,
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategoryId,
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(CategoryLocalizationHelper.translateCategory(context, cat.name)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),
              SizedBox(height: 12),
              RadioListTile<ExpenseType>(
                value: ExpenseType.expense,
                groupValue: _expenseType,
                activeColor: Colors.red,
                title: Text(AppLocalizations.of(context)!.expense),
                onChanged: (v) => setState(() => _expenseType = v!),
              ),
              RadioListTile<ExpenseType>(
                value: ExpenseType.income,
                groupValue: _expenseType,
                activeColor: Colors.teal,
                title: Text(AppLocalizations.of(context)!.income),
                onChanged: (v) => setState(() => _expenseType = v!),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.amount,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? AppLocalizations.of(context)!.emptyAmountMsg : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
