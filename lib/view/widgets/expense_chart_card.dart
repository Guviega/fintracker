import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChartCard extends StatelessWidget {
  const ExpenseChartCard({
    super.key,
    required this.title,
    required this.icon,
    required this.totals,
    required this.grandTotal,
    required this.formatCurrency,
  });

  final String title;
  final IconData icon;
  final List<MapEntry<String, double>> totals;
  final double grandTotal;
  final String Function(double) formatCurrency;

  static const _chartColors = <Color>[
    Colors.red,
    Colors.lightGreen,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.yellowAccent,
    Colors.deepOrange,
    Colors.pink,
    Colors.greenAccent,
  ];

  List<PieChartSectionData> _buildChartSections(double grandTotal) {
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < totals.length; i++) {
      final entry = totals[i];
      final percentage = (entry.value / grandTotal * 100).round();
      sections.add(
        PieChartSectionData(
          value: entry.value,
          title: '$percentage%',
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Colors.white,
          ),
          radius: 48,
          color: _chartColors[i % _chartColors.length],
        ),
      );
    }
    return sections;
  }

  Widget _buildChartLegend() {
    return Column(
      children: [
        for (var i = 0; i < totals.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _chartColors[i % _chartColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(totals[i].key, overflow: TextOverflow.ellipsis),
                ),
                Text(formatCurrency(totals[i].value)),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(icon),
            ),
            if (totals.isEmpty)
              const SizedBox(
                height: 160,
                child: Center(child: Text('No expenses to display')),
              )
            else ...[
              SizedBox(
                height: 160,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 28,
                    sections: _buildChartSections(grandTotal),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildChartLegend(),
            ],
          ],
        ),
      ),
    );
  }
}
