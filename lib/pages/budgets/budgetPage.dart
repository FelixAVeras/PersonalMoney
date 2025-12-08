import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/l10n/app_localizations_en.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/budgetModel.dart';
import 'package:personalmoney/pages/budgets/addBudget.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';
import 'package:personalmoney/helpers/DbHelper.dart'; // SQLHelper estático

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  SQLHelper sqlHelper = SQLHelper();

  final BudgetService budgetService = BudgetService();
  final FormatHelper formatHelper = FormatHelper();

  List<BudgetModel> budgets = [];
  Map<int, String> categoryNames = {}; // categoryId -> name map
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Carga inicial asíncrona
    WidgetsBinding.instance.addPostFrameCallback((_) {
      load();
    });
  }

  Future<void> load() async {
    setState(() {
      loading = true;
    });

    try {
      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      // 1) Cargar budgets (maps con category_name)
      final List<Map<String, dynamic>> budgetMaps =
          await SQLHelper.getBudgetsWithCategoryName(month, year);

      // Convertir a BudgetModel
      budgets = budgetMaps.map((m) => BudgetModel.fromMap(m)).toList();

      // 2) Cargar categorías (devuelve List<Map<String,dynamic>>)
      final List<CategoryModel> cats = await sqlHelper.getCategories();

      // crear mapa id -> name
      categoryNames = {
        for (var c in cats) (c.id): (c.name)
      };
    } catch (e, st) {
      debugPrint('Error cargando budgets: $e\n$st');
      budgets = [];
      categoryNames = {};
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';

  Color _balanceColor(BudgetModel b) {
    if (b.amount == 0) {
      return Theme.of(context).brightness == Brightness.light
      ? Colors.black
      : Colors.white;
    }
    
    final double percent = b.balance / b.amount;
    
    if (percent <= 0.10) return Colors.red;
    if (percent <= 0.20) return Colors.orange;
    
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.budget),
        actions: [
          IconButton(
            onPressed: () async {
              // Abrir AddBudgetPage y recargar al volver
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBudgetPage()),
              );
              await load(); // recargar al volver
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : budgets.isEmpty
              ? Center(child: Text(
                AppLocalizations.of(context)!.emptyBudgetMsg,
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)))
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      child: DataTable(
                        columnSpacing: 24,
                        columns: [
                          DataColumn(
                              label:
                                  Text(AppLocalizations.of(context)!.category)),
                          DataColumn(
                              label:
                                  Text(AppLocalizations.of(context)!.balance)),
                        ],
                        rows: budgets.map((b) {
                          final name =
                              categoryNames[b.categoryId] ?? 'Desconocida';
                          final balText = _formatCurrency(b.balance);

                          return DataRow(
                            cells: [
                              DataCell(Row(
                                children: [
                                  Icon(formatHelper.getCategoryIcon(name),
                                      size: 18),
                                  const SizedBox(width: 10.0),
                                  Flexible(
                                      child: Text(CategoryLocalizationHelper
                                          .translateCategory(context, name))),
                                ],
                              )),
                              DataCell(Text(
                                balText,
                                style: TextStyle(
                                    color: _balanceColor(b),
                                    fontWeight: FontWeight.w600),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
    );
  }
}
