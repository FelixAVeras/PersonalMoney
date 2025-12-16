// import 'package:flutter/material.dart';
// import 'package:personalmoney/helpers/DbHelper.dart';
// import 'package:personalmoney/helpers/SnakcHelper.dart';
// import 'package:personalmoney/helpers/category_localization_helper.dart';
// import 'package:personalmoney/l10n/app_localizations.dart';
// import 'package:personalmoney/models/CategoryModel.dart';
// import 'package:personalmoney/pages/budgets/budgetService.dart';

// class AddBudgetPage extends StatefulWidget {
//   const AddBudgetPage({super.key});

//   @override
//   State<AddBudgetPage> createState() => _AddBudgetPageState();
// }

// class _AddBudgetPageState extends State<AddBudgetPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController initialAmountController = TextEditingController();
//   final Map<int, TextEditingController> controllers = {};
//   List<CategoryModel> categories = [];
//   bool loading = true;

//   SQLHelper sqlHelper = SQLHelper();

//   bool hasInitialBudget = false;
//   double remainingBalance = 0.0;
//   Set<int> categoriesWithAmount = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadCats();
//   }

//   Future<void> _loadCats() async {
//     final now = DateTime.now();
//     final month = now.month;
//     final year = now.year;

//     categories = await sqlHelper.getCategories();

//     final budgets = await SQLHelper.getBudgetsWithCategoryName(month, year);

//     double initial = 0;
//     double used = 0;

//     for (var b in budgets) {
//       final amount = (b['amount'] as num?)?.toDouble() ?? 0.0;
//       final catId = b['category_id'] as int;

//       if (amount > 0) {
//         categoriesWithAmount.add(catId);
//         used += amount;
//       }

//       initial = (b['initial_amount'] as num?)?.toDouble() ?? initial;
//     }

//     if (initial > 0) {
//       hasInitialBudget = true;
//       remainingBalance = initial - used;
//     }

//     for (var c in categories) {
//       controllers[c.id] = TextEditingController();
//     }

//     setState(() => loading = false);
//   }


//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     final initial = double.tryParse(initialAmountController.text.replaceAll(',', '.'));
    
//     if (initial == null || initial <= 0) {
//       SnackHelper.showMessage(context, AppLocalizations.of(context)!.invalidInitialBalanceMsg);
//       return;
//     }

//     double sum = 0;
//     final Map<int, double> map = {};
    
//     for (var entry in controllers.entries) {
//       final text = entry.value.text.trim();
//       final v = text.isEmpty ? 0.0 : (double.tryParse(text.replaceAll(',', '.')) ?? 0.0);
//       map[entry.key] = v;
//       sum += v;
//     }

//     if ((sum - initial).abs() > 0.0001) {

//       SnackHelper.showMessage(
//         context, 
//         AppLocalizations.of(context)!.categoriesSumMustMatchInitial
//       );
    
//       return;
//     }

//     final now = DateTime.now();
//     final month = now.month;
//     final year = now.year;
//     final svc = BudgetService();
    
//     await svc.saveMonthlyDistribution(
//       initialAmount: initial,
//       categoryAmounts: map,
//       month: month,
//       year: year,
//     );

//     Navigator.pop(context, true);
//   }

//   @override
//   void dispose() {
//     initialAmountController.dispose();
//     controllers.values.forEach((c) => c.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//       ? Colors.grey.shade200
//       : const Color(0xFF1E1E1E),
//       appBar: AppBar(title: Text(AppLocalizations.of(context)!.addBudget)),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: initialAmountController,
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 decoration: InputDecoration(
//                   labelText: AppLocalizations.of(context)!.initialBalance,
//                   prefixIcon: Icon(Icons.attach_money),
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (v) => v == null || v.trim().isEmpty ? AppLocalizations.of(context)!.invalidInitialBalanceMsg : null,
//               ),
//               const SizedBox(height: 16),
//               Text(AppLocalizations.of(context)!.category, style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               ...categories.map((c) {
//                 final id = c.id;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: TextFormField(
//                     controller: controllers[id],
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: CategoryLocalizationHelper.translateCategory(context, c.name),
//                       prefixIcon: const Icon(Icons.attach_money),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _save,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal, 
//                   foregroundColor: Colors.white,
//                   elevation: 4
//                 ),
//                 icon: Icon(Icons.save_alt),
//                 label: Text(AppLocalizations.of(context)!.btnSaveChanges),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnackHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController initialAmountController =
      TextEditingController();

  final Map<int, TextEditingController> controllers = {};

  final SQLHelper sqlHelper = SQLHelper();

  List<CategoryModel> categories = [];

  bool loading = true;

  // 🔹 NUEVAS VARIABLES DE CONTROL
  bool hasInitialBudget = false;
  double remainingBalance = 0.0;
  Set<int> categoriesWithAmount = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final now = DateTime.now();
    final month = now.month;
    final year = now.year;

    // Categorías
    categories = await sqlHelper.getCategories();

    // Presupuestos actuales
    final budgets =
        await SQLHelper.getBudgetsWithCategoryName(month, year);

    double initial = 0.0;
    double used = 0.0;

    for (var b in budgets) {
      final double amount =
          (b['amount'] as num?)?.toDouble() ?? 0.0;
      final int catId = b['category_id'] as int;

      if (amount > 0) {
        categoriesWithAmount.add(catId);
        used += amount;
      }

      initial =
          (b['initial_amount'] as num?)?.toDouble() ?? initial;
    }

    if (initial > 0) {
      hasInitialBudget = true;
      remainingBalance = initial - used;
    }

    // Controllers solo para categorías visibles
    for (var c in categories) {
      controllers[c.id] = TextEditingController();
    }

    setState(() => loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final double initial = hasInitialBudget
        ? remainingBalance
        : double.tryParse(
                initialAmountController.text.replaceAll(',', '.')) ??
            0.0;

    if (initial <= 0) {
      SnackHelper.showMessage(
        context,
        AppLocalizations.of(context)!.invalidInitialBalanceMsg,
      );
      return;
    }

    double sum = 0.0;
    final Map<int, double> map = {};

    for (var entry in controllers.entries) {
      final text = entry.value.text.trim();
      final value = text.isEmpty
          ? 0.0
          : double.tryParse(text.replaceAll(',', '.')) ?? 0.0;

      map[entry.key] = value;
      sum += value;
    }

    if (sum > initial) {
      SnackHelper.showMessage(
        context,
        AppLocalizations.of(context)!.categoriesSumMustMatchInitial,
      );
      return;
    }

    final now = DateTime.now();

    await BudgetService().saveMonthlyDistribution(
      initialAmount: initial,
      categoryAmounts: map,
      month: now.month,
      year: now.year,
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    initialAmountController.dispose();
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade200
              : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addBudget),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),

              // 🔹 MONTO INICIAL O BALANCE RESTANTE
              if (!hasInitialBudget)
                TextFormField(
                  controller: initialAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.initialBalance,
                    prefixIcon: const Icon(Icons.attach_money),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? AppLocalizations.of(context)!
                          .invalidInitialBalanceMsg
                      : null,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${AppLocalizations.of(context)!.remainingBalance}: '
                    '\$${remainingBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              Text(
                AppLocalizations.of(context)!.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // 🔹 SOLO CATEGORÍAS SIN MONTO
              ...categories
                  .where((c) =>
                      !hasInitialBudget ||
                      !categoriesWithAmount.contains(c.id))
                  .map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: controllers[c.id],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText:
                          CategoryLocalizationHelper.translateCategory(
                              context, c.name),
                      prefixIcon:
                          const Icon(Icons.attach_money),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: remainingBalance <= 0 && hasInitialBudget
                    ? null
                    : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
                icon: const Icon(Icons.save_alt),
                label: Text(
                    AppLocalizations.of(context)!.btnSaveChanges),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
