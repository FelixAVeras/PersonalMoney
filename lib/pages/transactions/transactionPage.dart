import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/transactions/addTransaction.dart';
import 'package:personalmoney/pages/transactions/detailtransaction.dart';

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final SQLHelper sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();
  
  List<TransactionModel> _transactions = [];
  
  //TODO: Definir funcion addIncome(), sumar saldo a cantidad incial cuando tenga una transaccion con el tipo "Income"

  //TODO: Poder editar la cantidad inicial y que esta se refleje en Budgets

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    List<TransactionModel> transactions = await sqlHelper.getTransactions();
    
    setState(() => _transactions = transactions);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactions),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionPage()));
              
              _loadTransactions();
            },
            icon: Icon(Icons.add_circle_rounded),
            tooltip: AppLocalizations.of(context)!.addTransactionTitle,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
  if (_transactions.isEmpty) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.emptyTransactionMsg,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  final grouped = _groupByCategory();
  final categories = grouped.keys.toList();

  return ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final category = categories[index];
      final items = grouped[category]!;

      return Card.outlined(
        child: Column(
          children: [
            SizedBox(width: 10),
            Center(
              child: Text(
                CategoryLocalizationHelper.translateCategory(context, category),
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ),
            
            ...items.map((transaction) {
              return ListTile(
                leading: Icon(
                  transaction.transType == 'income'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: transaction.transType == 'income' ? Colors.green : Colors.red,
                ),
                title: Text(
                  transaction.name, 
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold)
                  ),
                subtitle: Text(formatHelper.formatDate(transaction.date.toString())),
                trailing: Text(
                  formatHelper.formatAmount(transaction.amount),
                  style: TextStyle(
                    color: transaction.transType == 'income' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailTransactionPage(transaction: transaction))
              ));
            }).toList(),
          ],
        )
      );
    },
  );
}


  Map<String, List<TransactionModel>> _groupByCategory() {
    Map<String, List<TransactionModel>> grouped = {};

    for (var t in _transactions) {
      String key = t.categoryName ?? "Unknow Category";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(t);
    }

    return grouped;
  }
}