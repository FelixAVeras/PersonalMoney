import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';
import 'package:personalmoney/pages/debts/addDebtsPage.dart';
import 'package:personalmoney/pages/debts/debtCard.dart';
import 'package:personalmoney/pages/debts/debtDetailsPage.dart';
// import 'package:personalmoney/l10n/app_localizations.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({Key? key}) : super(key: key);

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  final SQLHelper sqlHelper = SQLHelper();

  Future<List<Map<String, dynamic>>>? _debtsFuture;

  FormatHelper formatHelper = FormatHelper();

  @override
  void initState() {
    super.initState();
    _refreshDebts();
  }

  void _refreshDebts() {
    setState(() {
    _debtsFuture = sqlHelper.getAllDebtsWithBalance();
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        // title: Text(AppLocalizations.of(context)!.budget),
        title: Text('Deudas'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDebtsPage()));
              
              if (result == true) {
                _refreshDebts();
              }
            },
            icon: const Icon(Icons.add_circle),
            // tooltip: AppLocalizations.of(context)!.addBudget,
            tooltip: 'Agregar Deuda',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _debtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final debts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: debts.length,
            itemBuilder: (context, index) {
              final debt = debts[index];
  
              double total = (debt['total_amount'] as num).toDouble();
              double remaining = (debt['remaining_amount'] as num).toDouble();

              // Creamos el String
              String displayAmount;

              if (remaining < total) {
                // Si hay abonos, mostramos la flecha
                displayAmount = '${formatHelper.formatAmount(total)} → ${formatHelper.formatAmount(remaining)}';
              } else {
                // Si no hay abonos, solo el total
                displayAmount = formatHelper.formatAmount(total);
              }

              return DebtCard(
                description: debt['description'],
                amount: displayAmount,
                createdAt: debt['created_at'],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DebtDetailPage(debt: debt),
                    ),
                  );
    
                  _refreshDebts();
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No tienes deudas registradas",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          const Text("Toca el botón + para empezar"),
        ],
      ),
    );
  }
}