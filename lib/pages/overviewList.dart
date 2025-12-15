// import 'package:flutter/material.dart';
// import 'package:personalmoney/helpers/DbHelper.dart';
// import 'package:personalmoney/helpers/category_localization_helper.dart';
// import 'package:personalmoney/helpers/formatHelper.dart';
// import 'package:personalmoney/helpers/overviewHelper.dart';
// import 'package:personalmoney/l10n/app_localizations.dart';

// class OverviewList extends StatefulWidget {
//   @override
//   State<OverviewList> createState() => _OverviewListState();
// }

// class _OverviewListState extends State<OverviewList> {
//   final SQLHelper sqlHelper = SQLHelper();
//   final OverviewHelper overviewHelper = OverviewHelper();
//   final FormatHelper formatHelper = FormatHelper();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//       ? Colors.grey.shade200
//       : const Color(0xFF1E1E1E),
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.overview),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: sqlHelper.getOverviewData(), // Función que trae los datos de la DB
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No hay datos'));
//           } else {
//             final overviewData = snapshot.data!;

//             final filteredData = overviewData.where((row) => (row['amount'] ?? 0) > 0).toList();

//             // final double totalSpent = overviewData.fold(0.0, (sum, row) => sum + (row['spent'] * 1.0));
//             // final double totalLeft = overviewData.fold(0.0, (sum, row) => sum + ((row['amount'] - row['spent']) * 1.0));

//             final double totalSpent = filteredData.fold(0.0, (sum, row) => sum + (row['spent'] * 1.0));
//             final double totalAmount = filteredData.fold(0.0, (sum, row) => sum + (row['amount'] * 1.0));
//             final double totalLeft = totalAmount - totalSpent;

//             return SingleChildScrollView(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   _buildTotalCard(totalSpent, totalLeft),

//                   SizedBox(height: 8.0),

//                   Card.outlined(
//                     child: 
//                     // Responsive DataTable
//                     LayoutBuilder(
//                       builder: (context, constraints) {
//                         double tableWidth = constraints.maxWidth;

//                         return SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(minWidth: tableWidth),
//                             child: DataTable(
//                               columnSpacing: 2.0,
//                               columns: [
//                                 DataColumn(
//                                   label: Container(
//                                     width: tableWidth * 0.4,
//                                     child: Text(
//                                       AppLocalizations.of(context)!.category,
//                                       style: TextStyle(fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                                 DataColumn(
//                                   label: Container(
//                                     width: tableWidth * 0.3,
//                                     child: Text(
//                                       AppLocalizations.of(context)!.spent,
//                                       style: TextStyle(fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                                 DataColumn(
//                                   label: Container(
//                                     width: tableWidth * 0.3,
//                                     child: Text(
//                                       AppLocalizations.of(context)!.balance,
//                                       style: TextStyle(fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                               rows: overviewData.map((row) {
//                                 double amount = row["amount"] * 1.0;
//                                 double spent = row["spent"] * 1.0;
//                                 double balance = amount - spent;

//                                 return DataRow(
//                                   cells: [
//                                     DataCell(Container(
//                                       width: tableWidth * 0.4,
//                                       child: Text(CategoryLocalizationHelper.translateCategory(context, row["category_name"])),
//                                     )),
//                                     DataCell(Container(
//                                       width: tableWidth * 0.3,
//                                       child: Text(formatHelper.formatAmount(spent)),
//                                     )),
//                                     DataCell(Container(
//                                       width: tableWidth * 0.3,
//                                       child: Text(
//                                         formatHelper.formatAmount(balance),
//                                         style: TextStyle(
//                                           color: overviewHelper.getBalanceColor(amount, spent),
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     )),
//                                   ],
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildTotalCard(double totalSpent, double totalLeft) {
//     return Card.outlined(
//       child: Container(
//         width: double.infinity, // ocupa 100% del ancho
//         padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Spent
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.spent,
//                   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4.0),
//                 Text(
//                   formatHelper.formatAmount(totalSpent),
//                   style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
//                 ),
//               ],
//             ),

//             // Left
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.left,
//                   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4.0),
//                 Text(
//                   formatHelper.formatAmount(totalLeft),
//                   style: TextStyle(fontSize: 18.0, color: Colors.green),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.overview),
      ),
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
          final filteredData =
              overviewData.where((row) => (row['amount'] ?? 0) > 0).toList();

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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.spent,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.balance,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: tableWidth * 0.3,
                                      child: Text(
                                        formatHelper.formatAmount(spent),
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
      progressColor = Colors.red;
    } else if (progress >= 0.7) {
      progressColor = Colors.orange;
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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
            ),

            const SizedBox(height: 6),

            Text(
              '${(progress * 100).toStringAsFixed(0)}% ${AppLocalizations.of(context)!.spent}',
              style: const TextStyle(fontWeight: FontWeight.w600),
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
                children: const [
                  Icon(Icons.info_outline),
                  SizedBox(width: 12),
                  Text('No hay transacciones aún'),
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

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isIncome ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
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
                        isIncome ? 'Último ingreso' : 'Último gasto',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transacName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Text(
                      //   category,
                      //   style: Theme.of(context).textTheme.titleMedium,
                      // ),
                      if (description != null && description.isNotEmpty)
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  formatHelper.formatAmount(amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
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
