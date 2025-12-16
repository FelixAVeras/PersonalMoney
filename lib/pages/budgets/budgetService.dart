// services/budget_service.dart
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/MonthlyBalanceModel.dart';
import 'package:personalmoney/models/budgetModel.dart';

class BudgetService {
  SQLHelper _sqlHelper = SQLHelper();

  Future<void> saveMonthlyDistribution({
    required double initialAmount,
    required Map<int, double> categoryAmounts,
    required int month,
    required int year,
  }) async {

    double sum = categoryAmounts.values.fold(0, (a, b) => a + b);
    double remaining = initialAmount - sum;

    final categories = await _sqlHelper.getCategories();
    
    final others = categories.firstWhere(
      (c) => c.name.toLowerCase() == "others",
      orElse: () => categories.last,
    );

    // Si queda dinero sin asignar → mandarlo a Others
    if (remaining > 0) {
      categoryAmounts[others.id] = (categoryAmounts[others.id] ?? 0) + remaining;
    }

    // Guardar MonthlyBalance
    await SQLHelper.insertMonthlyBalance(
      MonthlyBalanceModel(
        initialBalance: initialAmount,
        spent: 0,
        month: month,
        year: year,
      ),
    );

    // Guardar categorías
    for (final entry in categoryAmounts.entries) {
      final categoryId = entry.key;
      final amount = entry.value;

      final existing = await _sqlHelper.getBudgetByCategoryMonth(categoryId, month, year);

      if (existing != null) {
        await _sqlHelper.updateBudget(existing.copyWith(amount: amount));
      } else {
        await SQLHelper.insertBudget(
          BudgetModel(
            categoryId: categoryId,
            amount: amount,
            spent: 0,
            month: month,
            year: year,
          ),
        );
      }
    }
  }

  /// Agregar gasto a una categoría y al balance mensual
  Future<void> applyTransactionExpense({
    required int categoryId,
    required int month,
    required int year,
    required double amount,
  }) async {
    await _sqlHelper.addSpentToBudget(categoryId, month, year, amount);
    await _sqlHelper.addSpentToMonthlyBalance(month, year, amount);
  }

  /// Quitar gasto cuando se BORRA o EDITA una transacción
  Future<void> revertTransactionExpense({
    required int categoryId,
    required int month,
    required int year,
    required double amount,
  }) async {
    await _sqlHelper.subtractSpentFromBudget(categoryId, month, year, amount);
    await _sqlHelper.subtractSpentFromMonthlyBalance(month, year, amount);
  }

  /// Gasto directo (sin monthlyBalance)
  Future<void> subtractFromCategory({
    required int categoryId,
    required int month,
    required int year,
    required double amount,
  }) async {
    BudgetModel? budget =
        await _sqlHelper.getBudgetByCategoryMonth(categoryId, month, year);

    if (budget == null) {
      print("❌ No existe presupuesto para esta categoría ($categoryId) en $month/$year");
      return;
    }

    double newSpent = budget.spent + amount;

    BudgetModel updated = budget.copyWith(spent: newSpent);

    await _sqlHelper.updateBudget(updated);

    // Importantísimo ✔️
    await _sqlHelper.addSpentToMonthlyBalance(month, year, amount);
  }

  Future<void> addToCategory(int categoryId, double amount) async {
    DateTime now = DateTime.now();
    int month = now.month;
    int year = now.year;

    await applyTransactionExpense(
      categoryId: categoryId,
      month: month,
      year: year,
      amount: amount,
    );
  }

  Future<void> updateBudget(BudgetModel budget) async {
    final db = await SQLHelper.db();

    await db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }
}
