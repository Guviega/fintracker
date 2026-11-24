import 'package:fintracker/imdb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    required this.onIncomeTap,
    required this.onExpensesTap,
  });

  final VoidCallback onIncomeTap;
  final VoidCallback onExpensesTap;

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  late DateTime _selectedMonth;

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
    Colors.greenAccent
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  bool isOnProfit() {
    return Imdb.getTotalResultbyMonth(_selectedMonth) >= 0;
  }

  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'R\$ $whole,${parts[1]}';
  }

  List<MapEntry<String, double>> _expenseTotalsByPaymentMethod() {
    final totals = Imdb.getExpenseTotalsByPaymentMethod(_selectedMonth).entries
        .map((entry) => MapEntry(entry.key.name, entry.value))
        .toList();
    totals.sort((a, b) => b.value.compareTo(a.value));
    return totals;
  }

  List<MapEntry<String, double>> _expenseTotalsByCategory() {
    final totals = Imdb.getExpenseTotalsByCategory(_selectedMonth).entries.toList();
    totals.sort((a, b) => b.value.compareTo(a.value));
    return totals;
  }

  List<PieChartSectionData> _buildChartSections(
    List<MapEntry<String, double>> totals,
    double grandTotal,
  ) {
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

  Widget _buildChartLegend(List<MapEntry<String, double>> totals) {
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
                Text(_formatCurrency(totals[i].value)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _expenseChartCard({
    required String title,
    required IconData icon,
    required List<MapEntry<String, double>> totals,
  }) {
    final grandTotal = Imdb.getTotalExpensesbyMonth(_selectedMonth);

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                    sections: _buildChartSections(totals, grandTotal),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildChartLegend(totals),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableMonths = Imdb.getAvailableMonths();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 12),
                  const Text('Month', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<DateTime>(
                      isExpanded: true,
                      value: _selectedMonth,
                      items: [
                        for (final month in availableMonths)
                          DropdownMenuItem(
                            value: month,
                            child: Text(DateFormat.yMMMM().format(month)),
                          ),
                      ],
                      onChanged: (month) {
                        if (month == null) return;
                        setState(() => _selectedMonth = month);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(
                Icons.account_balance,
                color: isOnProfit() ? Colors.green : Colors.red,
                size: 36,
              ),
              title: const Text("Total Result", style: TextStyle(fontSize: 14)),
              subtitle: Text(
                _formatCurrency(Imdb.getTotalResultbyMonth(_selectedMonth)),
                style: TextStyle(
                  color: isOnProfit() ? Colors.green : Colors.red,
                  fontWeight: .bold,
                  fontSize: 22,
                ),
              ),
              trailing: Text(
                Imdb.getTotalResultbyMonth(_selectedMonth) == 0
                    ? ''
                    : isOnProfit()
                    ? 'PROFIT'
                    : 'LOSS',
                style: TextStyle(
                  fontSize: 14,
                  color: isOnProfit() ? Colors.green : Colors.red,
                  fontWeight: .bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  child: InkWell(
                    onTap: widget.onIncomeTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: const Text(
                            'Total Income',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 12),
                            Text(
                              '+ ${_formatCurrency(Imdb.getTotalIncomebyMonth(_selectedMonth))}',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: .bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 1,
                  child: InkWell(
                    onTap: widget.onExpensesTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: const Text(
                            'Total Expenses',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: const Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "- ${_formatCurrency(Imdb.getTotalExpensesbyMonth(_selectedMonth))}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final paymentTotals = _expenseTotalsByPaymentMethod();
              final categoryTotals = _expenseTotalsByCategory();
              final charts = [
                _expenseChartCard(
                  title: 'Expenses by Payment Method',
                  icon: Icons.credit_card,
                  totals: paymentTotals,
                ),
                _expenseChartCard(
                  title: 'Expenses by Category',
                  icon: Icons.category_outlined,
                  totals: categoryTotals,
                ),
              ];
              if (constraints.maxWidth < 600) {
                return Column(children: [for (final chart in charts) chart]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final chart in charts)
                    Expanded(child: chart),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
