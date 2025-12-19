import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/category_localization_helper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/overviewHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';

class OverviewList extends StatefulWidget {
  @override
  State<OverviewList> createState() => _OverviewListState();
}

class _OverviewListState extends State<OverviewList> {
  final SQLHelper sqlHelper = SQLHelper();
  final OverviewHelper overviewHelper = OverviewHelper();
  final FormatHelper formatHelper = FormatHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade200
          : const Color(0xFF1E1E1E),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.overview)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sqlHelper.getOverviewData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos'));
          }

          final overviewData = snapshot.data!;

          // 🔹 Filtrar solo categorías con presupuesto asignado
          final filteredData = overviewData.where((row) => (row['amount'] ?? 0) > 0).toList();

          if (filteredData.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.emptyBudgetMsg),
            );
          }

          // 🔹 Totales
          final double totalSpent = filteredData.fold(
              0.0, (sum, row) => sum + (row['spent'] * 1.0));

          final double totalAmount = filteredData.fold(
              0.0, (sum, row) => sum + (row['amount'] * 1.0));

          final double totalLeft = totalAmount - totalSpent;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                _buildTotalCard(totalSpent, totalLeft, totalAmount),

                const SizedBox(height: 8),

                _buildLastTransactionCard(),

                const SizedBox(height: 8),

                Card.outlined(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double tableWidth = constraints.maxWidth;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: tableWidth),
                          child: DataTable(
                            columnSpacing: 2,
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: tableWidth * 0.4,
                                  child: Text(
                                    AppLocalizations.of(context)!.category,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.spent,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.balance,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,),
                                  ),
                                ),
                              ),
                            ],
                            rows: filteredData.map((row) {
                              final double amount = row['amount'] * 1.0;
                              final double spent = row['spent'] * 1.0;
                              final double balance = amount - spent;

                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: tableWidth * 0.4,
                                      child: Text(
                                        CategoryLocalizationHelper
                                            .translateCategory(
                                                context,
                                                row['category_name']),
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: tableWidth * 0.3,
                                      child: Text(
                                        formatHelper.formatAmount(spent),
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: tableWidth * 0.3,
                                      child: Text(
                                        formatHelper.formatAmount(balance),
                                        style: TextStyle(
                                          color: overviewHelper
                                              .getBalanceColor(
                                                  amount, spent),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= TOTAL CARD =================

  Widget _buildTotalCard(double totalSpent, double totalLeft, double totalAmount) {
    final double progress = totalAmount <= 0
        ? 0
        : (totalSpent / totalAmount).clamp(0.0, 1.0);

    Color progressColor;
    if (progress >= 0.9) {
      progressColor = Color(0xFFFF7851);
    } else if (progress >= 0.7) {
      progressColor = Color(0xFFFFCE67);
    } else {
      progressColor = Colors.green;
    }

    return Card.outlined(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.spent,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatHelper.formatAmount(totalSpent),
                      style: const TextStyle(
                          fontSize: 18, color: Colors.redAccent),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.left,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatHelper.formatAmount(totalLeft),
                      style: const TextStyle(
                          fontSize: 18, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(progressColor),
              borderRadius: BorderRadiusGeometry.circular(10),
            ),

            const SizedBox(height: 6),

            Text(
              '${(progress * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.spent}',
              style: TextStyle(
                fontWeight: FontWeight.w600, 
                color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Last Expese/Income
  Widget _buildLastTransactionCard() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: sqlHelper.getLastTransaction(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 12),
                  Text(
                    'No hay transacciones aún',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final tx = snapshot.data!;
        final transacName = tx['name'];
        final isIncome = tx['type'] == 'income';
        final amount = tx['amount'];
        // final category = tx['category'];
        final description = tx['description'];
        final date = formatHelper.formatDate(tx['date']);

        print(tx);

        return Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isIncome ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isIncome 
                          ? AppLocalizations.of(context)!.lastSpend 
                          : AppLocalizations.of(context)!.lastIncome,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                          fontSize: 12
                        )
                          
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transacName,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                          fontSize: 12
                        )
                      ),
                    ],
                  ),
                ),
                Text(
                  formatHelper.formatAmount(amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Color(0xFFFF7851),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
