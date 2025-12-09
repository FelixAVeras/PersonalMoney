// import 'package:personalmoney/helpers/DbHelper.dart';
// import 'package:personalmoney/models/TransactionModel.dart';
// import 'package:personalmoney/pages/budgets/budgetService.dart';

// class TransactionService {
//   final SQLHelper db = SQLHelper();
//   final BudgetService budgetService = BudgetService();

//   /// ============================================
//   ///   UPDATE TRANSACTION + FIX BUDGET
//   /// ============================================
//   Future<bool> updateTransactionWithBudget(TransactionModel newTx) async {
//     try {
//       // Obtener la transacción original
//       final oldTxMap = await db.getTransactionById(newTx.id!);

//       if (oldTxMap == null) return false;

//       final oldTx = TransactionModel.fromMap(oldTxMap);

//       // ============================
//       //  Si era gasto, sumar al budget
//       // ============================
//       if (oldTx.transType == "expense") {
//         await budgetService.addToCategory(oldTx.categoryId!, oldTx.amount);
//       }

//       // ============================
//       //  Actualizar transacción
//       // ============================
//       await db.updateTransaction(newTx);

//       // ============================
//       //  Si sigue siendo gasto, restar de budget
//       // ============================
//       if (newTx.transType == "expense") {
//         await budgetService.subtractFromCategory(newTx.categoryId!, newTx.amount);
//       }

//       return true;
//     } catch (e) {
//       print("❌ Error actualizando transacción: $e");
//       return false;
//     }
//   }

//   /// ============================================
//   ///   DELETE TRANSACTION + FIX BUDGET
//   /// ============================================
//   Future<bool> deleteTransactionWithBudget(int id) async {
//     try {
//       // Obtener transacción antes de borrarla
//       final txMap = await db.getTransactionById(id);
//       if (txMap == null) return false;

//       final tx = TransactionModel.fromMap(txMap);

//       // Si era gasto → devolver al presupuesto
//       if (tx.transType == "expense") {
//         await budgetService.addToCategory(tx.categoryId!, tx.amount);
//       }

//       // Eliminar transacción
//       await db.deleteTransaction(id);

//       return true;
//     } catch (e) {
//       print("❌ Error eliminando transacción: $e");
//       return false;
//     }
//   }
// }
