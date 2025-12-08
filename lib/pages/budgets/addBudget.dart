import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/l10n/app_localizations_en.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController initialAmountController = TextEditingController();
  final Map<int, TextEditingController> controllers = {};
  List<CategoryModel> categories = [];
  bool loading = true;

  SQLHelper sqlHelper = SQLHelper();

  @override
  void initState() {
    super.initState();
    _loadCats();
  }

  Future<void> _loadCats() async {
    categories = await sqlHelper.getCategories();

    for (var c in categories) {
      controllers[c.id] = TextEditingController();
    }
    
    setState(() => loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final initial = double.tryParse(initialAmountController.text.replaceAll(',', '.'));
    
    if (initial == null || initial <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Monto inicial inválido')));
      return;
    }

    double sum = 0;
    final Map<int, double> map = {};
    
    for (var entry in controllers.entries) {
      final text = entry.value.text.trim();
      final v = text.isEmpty ? 0.0 : (double.tryParse(text.replaceAll(',', '.')) ?? 0.0);
      map[entry.key] = v;
      sum += v;
    }

    if ((sum - initial).abs() > 0.0001) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La suma de las categorías debe ser igual a la cantidad inicial. (Suma actual: $sum)')));
    
      return;
    }

    final now = DateTime.now();
    final month = now.month;
    final year = now.year;
    final svc = BudgetService();
    
    await svc.saveMonthlyDistribution(
      initialAmount: initial,
      categoryAmounts: map,
      month: month,
      year: year,
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    initialAmountController.dispose();
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addBudget)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 5),
              TextFormField(
                controller: initialAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.initialBalance,
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? AppLocalizations.of(context)!.invalidInitialBalanceMsg : null,
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.category, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...categories.map((c) {
                final id = c.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: controllers[id],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: CategoryLocalizationHelper.translateCategory(context, c.name),
                      prefixIcon: const Icon(Icons.attach_money),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, 
                  foregroundColor: Colors.white,
                  elevation: 4
                ),
                icon: Icon(Icons.save_alt),
                label: Text(AppLocalizations.of(context)!.btnSaveChanges),
              )
            ],
          ),
        ),
      ),
    );
  }
}
