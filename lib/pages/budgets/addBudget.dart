// import 'package:flutter/material.dart';
// import 'package:personalmoney/helpers/DbHelper.dart';
// import 'package:personalmoney/helpers/category_localization_helper.dart';
// import 'package:personalmoney/l10n/app_localizations.dart';
// import 'package:personalmoney/models/CategoryModel.dart';
// import 'package:personalmoney/models/budgetModel.dart';
// import 'package:personalmoney/models/monthlyBalanceModel.dart';

// class AddBudgetPage extends StatefulWidget {
//   const AddBudgetPage({super.key});

//   @override
//   State<AddBudgetPage> createState() => _AddBudgetPageState();
// }

// class _AddBudgetPageState extends State<AddBudgetPage> {
//   final SQLHelper _sqlHelper = SQLHelper();

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController initialAmountController = TextEditingController();

//   List<CategoryModel> categories = [];
//   int? _selectedCategoryId;

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     categories = await _sqlHelper.getCategories();
//     setState(() {});
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_selectedCategoryId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Seleccione una categoría")),
//       );
//       return;
//     }

//     final double initialAmount = double.parse(initialAmountController.text);

//     // 1. Guardar el balance inicial del mes
//     MonthlyBalanceModel mb = MonthlyBalanceModel(
//       month: '', 
//       year: null, 
//       initialAmount: null
//     );
//     await _sqlHelper.insertMonthlyBalance(mb);

//     // 2. Crear el presupuesto de la categoría seleccionada
//     BudgetModel bm = BudgetModel(
//       categoryId: _selectedCategoryId!,
//       amount: initialAmount,
//       spent: 0,
//     );
//     await _sqlHelper.insertBudget(bm);

//     Navigator.pop(context, true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.addBudget),
//         actions: [
//           IconButton(
//             onPressed: _save,
//             icon: const Icon(Icons.save_alt),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 10),

//               // Monto inicial (salario del mes)
//               TextFormField(
//                 controller: initialAmountController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   label: Text("Monto inicial del mes"),
//                   prefixIcon: Icon(Icons.attach_money),
//                 ),
//                 validator: (value) =>
//                     value!.isEmpty ? "Inserte un monto" : null,
//               ),

//               const SizedBox(height: 20),

//               const Text(
//                 "Categoría del presupuesto",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),

//               DropdownButtonFormField<int>(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 items: categories.map((cat) {
//                   return DropdownMenuItem(
//                     value: cat.id,
//                     child: Text(
//                       CategoryLocalizationHelper.translateCategory(
//                         context,
//                         cat.name,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 value: _selectedCategoryId,
//                 onChanged: (value) {
//                   setState(() => _selectedCategoryId = value);
//                 },
//                 validator: (value) =>
//                     value == null ? "Seleccione una categoría" : null,
//               ),

//               const SizedBox(height: 30),
//               ElevatedButton.icon(
//                 onPressed: _save,
//                 icon: const Icon(Icons.check),
//                 label: const Text("Guardar Presupuesto"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                 ),
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

    // parse initial
    final initial = double.tryParse(initialAmountController.text.replaceAll(',', '.'));
    if (initial == null || initial <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Monto inicial inválido')));
      return;
    }

    // build map category->amount
    double sum = 0;
    final Map<int, double> map = {};
    for (var entry in controllers.entries) {
      final text = entry.value.text.trim();
      final v = text.isEmpty ? 0.0 : (double.tryParse(text.replaceAll(',', '.')) ?? 0.0);
      map[entry.key] = v;
      sum += v;
    }

    // validation: sum must equal initial (you requested strict equality)
    if ((sum - initial).abs() > 0.0001) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La suma de las categorías debe ser igual a la cantidad inicial. (Suma actual: $sum)')));
      return;
    }

    final now = DateTime.now();
    final month = now.month;
    final year = now.year;

    // Save using service
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
      appBar: AppBar(title: const Text('Asignar Presupuesto (Distribución)')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: initialAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Cantidad Inicial',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese cantidad inicial' : null,
              ),
              const SizedBox(height: 16),
              const Text('Categorias', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...categories.map((c) {
                final id = c.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    controller: controllers[id],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: c.name,
                      prefixIcon: const Icon(Icons.attach_money),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar Distribución'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
