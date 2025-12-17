import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnackHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/budgets/budgetService.dart';
import 'package:personalmoney/pages/transactions/editTransactionPage.dart';

class DetailTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const DetailTransactionPage({required this.transaction, super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();
  final BudgetService budgetService = BudgetService();

  /// ➤ Navegar al editar
  updateTransaction() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionPage(transaction: widget.transaction),
      ),
    );

    if (updated == true) {
      setState(() {});
    }
  }

  /// ➤ Eliminar transacción
  deleteTransaction(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete, style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Colors.white,
        ),),
        content: Text(AppLocalizations.of(context)!.deleteConfirm, style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
          ),),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.delete),
            onPressed: () {
              Navigator.pop(context, true);

              SnackHelper.showMessage(context, 'Transaccion Eliminada');
            }
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Si era un gasto, devolver el monto al presupuesto
    if (widget.transaction.transType == "expense") {
      await budgetService.addToCategory(
        widget.transaction.categoryId!,
        widget.transaction.amount,
      );
    }

    await _sqlHelper.deleteTransaction(id);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailTransactionTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.transaction.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                          ),
                        ),
                        Text(
                          CategoryLocalizationHelper.translateCategory(
                            context,
                            widget.transaction.categoryName ?? '',
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  Text(
                    formatHelper.formatAmount(widget.transaction.amount),
                    style: TextStyle(fontSize: 16, color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    widget.transaction.transType == 'income'
                        ? AppLocalizations.of(context)!.income
                        : AppLocalizations.of(context)!.expense,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.transaction.transType == 'income'
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    formatHelper.formatDate(widget.transaction.date.toString()),
                    style: TextStyle(fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,),
                  ),

                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                          onPressed: updateTransaction,
                          icon: Icon(Icons.edit),
                          label:
                              Text(AppLocalizations.of(context)!.edit),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () =>
                              deleteTransaction(widget.transaction.id!),
                          icon: Icon(Icons.delete),
                          label:
                              Text(AppLocalizations.of(context)!.delete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
