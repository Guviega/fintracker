import 'package:fintracker/database/database_helper.dart';
import 'package:fintracker/database/monthly_dashboard_data.dart';
import 'package:fintracker/view/widgets/expense_chart_card.dart';
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
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late DateTime _selectedMonth;
  late Future<MonthlyDashboardData> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
    _dashboardFuture = DatabaseHelper.instance.getDashboardData(_selectedMonth);
  }

  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'R\$ $whole,${parts[1]}';
  }

  void _selectMonth(DateTime month) {
    setState(() {
      _selectedMonth = month;
      _dashboardFuture = DatabaseHelper.instance.getDashboardData(month);
    });
  }

  List<MapEntry<String, double>> _sortedEntries(Map<String, double> values) {
    final entries = values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MonthlyDashboardData>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _dashboardFuture = DatabaseHelper.instance.getDashboardData(
                    _selectedMonth,
                  );
                });
              },
              child: const Text('Could not load the dashboard. Retry.'),
            ),
          );
        }
        return _buildDashboard(snapshot.data!);
      },
    );
  }

  Widget _buildDashboard(MonthlyDashboardData data) {
    final isOnProfit = data.totalResult >= 0;
    final paymentTotals =
        data.expenseTotalsByPaymentMethod.entries
            .map((entry) => MapEntry(entry.key.name, entry.value))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final categoryTotals = _sortedEntries(data.expenseTotalsByCategory);

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
                  const Text(
                    'Month',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<DateTime>(
                      isExpanded: true,
                      value: _selectedMonth,
                      items: [
                        for (final month in data.availableMonths)
                          DropdownMenuItem(
                            value: month,
                            child: Text(DateFormat.yMMMM().format(month)),
                          ),
                      ],
                      onChanged: (month) {
                        if (month != null) _selectMonth(month);
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
                color: isOnProfit ? Colors.green : Colors.red,
                size: 36,
              ),
              title: const Text('Total Result', style: TextStyle(fontSize: 14)),
              subtitle: Text(
                _formatCurrency(data.totalResult),
                style: TextStyle(
                  color: isOnProfit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              trailing: Text(
                data.totalResult == 0
                    ? ''
                    : isOnProfit
                    ? 'PROFIT'
                    : 'LOSS',
                style: TextStyle(
                  fontSize: 14,
                  color: isOnProfit ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
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
                            const SizedBox(width: 12),
                            Text(
                              '+ ${_formatCurrency(data.totalIncome)}',
                              style: const TextStyle(
                                color: Colors.green,
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
                              '- ${_formatCurrency(data.totalExpenses)}',
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
              final charts = [
                ExpenseChartCard(
                  title: 'Expenses by Payment Method',
                  icon: Icons.credit_card,
                  totals: paymentTotals,
                  grandTotal: data.totalExpenses,
                  formatCurrency: _formatCurrency,
                ),
                ExpenseChartCard(
                  title: 'Expenses by Category',
                  icon: Icons.category_outlined,
                  totals: categoryTotals,
                  grandTotal: data.totalExpenses,
                  formatCurrency: _formatCurrency,
                ),
              ];
              if (constraints.maxWidth < 600) {
                return Column(children: charts);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (final chart in charts) Expanded(child: chart)],
              );
            },
          ),
        ],
      ),
    );
  }
}
