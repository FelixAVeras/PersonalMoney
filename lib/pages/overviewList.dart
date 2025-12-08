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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.overview),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sqlHelper.getOverviewData(), // Función que trae los datos de la DB
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay datos'));
          } else {
            final overviewData = snapshot.data!;

            final double totalSpent = overviewData.fold(0.0, (sum, row) => sum + (row['spent'] * 1.0));
            final double totalLeft = overviewData.fold(0.0, (sum, row) => sum + ((row['amount'] - row['spent']) * 1.0));

            return SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildTotalCard(totalSpent, totalLeft),

                  SizedBox(height: 8.0),

                  // Responsive DataTable
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double tableWidth = constraints.maxWidth;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: tableWidth),
                          child: DataTable(
                            columnSpacing: 16.0,
                            columns: [
                              DataColumn(
                                label: Container(
                                  width: tableWidth * 0.4,
                                  child: Text(
                                    AppLocalizations.of(context)!.category,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.spent,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  width: tableWidth * 0.3,
                                  child: Text(
                                    AppLocalizations.of(context)!.balance,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                            rows: overviewData.map((row) {
                              double amount = row["amount"] * 1.0;
                              double spent = row["spent"] * 1.0;
                              double balance = amount - spent;

                              return DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: tableWidth * 0.4,
                                    child: Text(CategoryLocalizationHelper.translateCategory(context, row["category_name"])),
                                  )),
                                  DataCell(Container(
                                    width: tableWidth * 0.3,
                                    child: Text(formatHelper.formatAmount(spent)),
                                  )),
                                  DataCell(Container(
                                    width: tableWidth * 0.3,
                                    child: Text(
                                      formatHelper.formatAmount(balance),
                                      style: TextStyle(
                                        color: overviewHelper.getBalanceColor(amount, spent),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTotalCard(double totalSpent, double totalLeft) {
    return Card.outlined(
      child: Container(
        width: double.infinity, // ocupa 100% del ancho
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Spent
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Spent',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  formatHelper.formatAmount(totalSpent),
                  style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
                ),
              ],
            ),

            // Left
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Left',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  formatHelper.formatAmount(totalLeft),
                  style: TextStyle(fontSize: 18.0, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}