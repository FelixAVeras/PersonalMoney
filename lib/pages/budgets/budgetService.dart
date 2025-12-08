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
    await SQLHelper.insertMonthlyBalance(
      MonthlyBalanceModel(
        initialBalance: initialAmount,
        spent: 0,
        month: month,
        year: year,
      ),
    );

    for (final entry in categoryAmounts.entries) {
      final categoryId = entry.key;
      final amount = entry.value;

      final existing = await _sqlHelper.getBudgetByCategoryMonth(categoryId, month, year);
      
      if (existing != null) {
        await _sqlHelper.updateBudget(existing.copyWith(amount: amount));
      } else {
        await SQLHelper.insertBudget(BudgetModel(
          categoryId: categoryId,
          amount: amount,
          spent: 0,
          month: month,
          year: year,
        ));
      }
    }
  }

  Future<void> applyTransactionExpense({
    required int categoryId,
    required int month,
    required int year,
    required double amount,
  }) async {
    await SQLHelper.addSpentToBudget(categoryId, month, year, amount);
    await SQLHelper.addSpentToMonthlyBalance(month, year, amount);
  }

  Future<void> subtractFromCategory(int categoryId, double amount) async {
    BudgetModel? budget = await _sqlHelper.getBudgetByCategory(categoryId);

    if (budget == null) {
      print("❌ No existe presupuesto para esta categoría: $categoryId");
      return;
    }

    double newSpent = budget.spent + amount;

    if (newSpent > budget.amount) {
      print("⚠️ El gasto supera el presupuesto asignado.");
    }

    BudgetModel updated = BudgetModel(
      id: budget.id,
      categoryId: budget.categoryId,
      amount: budget.amount,
      spent: newSpent,
      month: budget.month,
      year: budget.year,
    );

    await _sqlHelper.updateBudget(updated);
  }
}
