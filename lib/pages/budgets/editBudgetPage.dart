import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/SnackHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/budgetModel.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';

class EditBudgetPage extends StatefulWidget {
  final BudgetModel budget;
  final String categoryName;

  const EditBudgetPage({
    super.key,
    required this.budget,
    required this.categoryName,
  });

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final BudgetService budgetService = BudgetService();
  final FormatHelper formatHelper = FormatHelper();

  late TextEditingController amountCtrl;

  @override
  void initState() {
    super.initState();
    amountCtrl = TextEditingController(
      text: widget.budget.amount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    super.dispose();
  }
  
  Future<void> _save() async {
    final newAmount = double.tryParse(amountCtrl.text);

    if (newAmount == null || newAmount <= 0) {
      SnackHelper.showMessage(context, 'Monto inválido');

      return;
    }

    final updated = widget.budget.copyWith(
      amount: newAmount,
    );

    await budgetService.updateBudget(updated);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Presupuesto mensual',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$ ',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_alt),
                    label: Text(AppLocalizations.of(context)!.btnSaveChanges),
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