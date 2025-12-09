// import 'package:flutter/material.dart';
// import 'package:personalmoney/l10n/app_localizations.dart';

// class TrendsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//       ? Colors.grey.shade200
//       : const Color(0xFF1E1E1E),
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.trends),
//       ),
//       body: Center(child: Text('Pantalla de Tendencias')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personalmoney/helpers/DbHelper.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  SQLHelper sqlHelper = SQLHelper();

  Future<List<Map<String, dynamic>>> _loadData() async {
    final int month = DateTime.now().month;
    final int year = DateTime.now().year;
    
    return sqlHelper.getCategorySpending(month, year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trends")),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("No hay gastos este mes"));
          }

          return Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                    sections: _generateSections(data),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLegend(data),
            ],
          );
        },
      ),
    );
  }

  // ==========================
  // PIE CHART SECTIONS
  // ==========================
  List<PieChartSectionData> _generateSections(List<Map<String, dynamic>> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    return List.generate(data.length, (i) {
      final item = data[i];
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: (item['total'] as num).toDouble(),
        title: "",
        radius: 80,
      );
    });
  }

  // ==========================
  // LEGEND
  // ==========================
  Widget _buildLegend(List<Map<String, dynamic>> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    return Column(
      children: List.generate(data.length, (i) {
        final item = data[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 14, height: 14, color: colors[i % colors.length]),
              const SizedBox(width: 8),
              Text("${item['category']} — ${item['total']}"),
            ],
          ),
        );
      }),
    );
  }
}
