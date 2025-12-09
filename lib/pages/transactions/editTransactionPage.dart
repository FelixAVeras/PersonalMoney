import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionPage({required this.transaction, super.key});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final SQLHelper sql = SQLHelper();
  final BudgetService budgetService = BudgetService();
  final FormatHelper formatHelper = FormatHelper();

  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();

  List<CategoryModel> categories = [];
  int? selectedCategoryId;
  String selectedType = "expense";

  @override
  void initState() {
    super.initState();
    descriptionCtrl.text = widget.transaction.name;
    amountCtrl.text = widget.transaction.amount.toString();

    selectedCategoryId = widget.transaction.categoryId;
    selectedType = widget.transaction.transType;
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await sql.getCategories();
    setState(() {});
  }

  Future<void> saveChanges() async {
    final description = descriptionCtrl.text.trim();
    final raw = amountCtrl.text.replaceAll(".", "").replaceAll(",", ".");
    final amount = double.tryParse(raw);

    if (amount == null || amount <= 0) return;

    // Si cambia montos o tipo, ajustar presupuesto
    if (widget.transaction.transType == "expense") {
      await budgetService.addToCategory(widget.transaction.categoryId!, widget.transaction.amount);
    }

    if (selectedType == "expense") {
      await budgetService.subtractFromCategory(
        categoryId: selectedCategoryId!,
        amount: amount,
        month: DateTime.now().month,
        year: DateTime.now().year
      );
    }

    final updated = TransactionModel(
      id: widget.transaction.id,
      name: description,
      amount: amount,
      date: widget.transaction.date,
      transType: selectedType,
      categoryId: selectedCategoryId,
      month: widget.transaction.month,
      year: widget.transaction.year,
    );

    await sql.updateTransaction(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTransactionTitle),
        actions: [
          IconButton(
            onPressed: () => saveChanges, 
            icon: Icon(Icons.save_alt), 
            tooltip: AppLocalizations.of(context)!.btnSaveChanges
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: descriptionCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.description,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.amount,
            ),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<int>(
            value: selectedCategoryId,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.category,
            ),
            items: categories.map((cat) {
              return DropdownMenuItem(
                value: cat.id,
                child: Text(
                  CategoryLocalizationHelper.translateCategory(context, cat.name),
                ),
              );
            }).toList(),
            onChanged: (v) => setState(() => selectedCategoryId = v),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.transactionType,
            ),
            items: [
              DropdownMenuItem(value: "income", child: Text(AppLocalizations.of(context)!.income)),
              DropdownMenuItem(value: "expense", child: Text(AppLocalizations.of(context)!.expense)),
            ],
            onChanged: (v) => setState(() => selectedType = v!),
          ),

          // const SizedBox(height: 30),

          // ElevatedButton(
          //   onPressed: saveChanges,
          //   child: Text(AppLocalizations.of(context)!.btnSaveChanges),
          // )
        ],
      ),
    );
  }
}
