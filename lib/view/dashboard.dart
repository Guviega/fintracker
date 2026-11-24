import 'package:fintracker/imdb.dart';
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
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  late DateTime _selectedMonth;

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
    final totals = Imdb.getExpenseTotalsByPaymentMethod(
      _selectedMonth,
    ).entries.map((entry) => MapEntry(entry.key.name, entry.value)).toList();
    totals.sort((a, b) => b.value.compareTo(a.value));
    return totals;
  }

  List<MapEntry<String, double>> _expenseTotalsByCategory() {
    final totals = Imdb.getExpenseTotalsByCategory(
      _selectedMonth,
    ).entries.toList();
    totals.sort((a, b) => b.value.compareTo(a.value));
    return totals;
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
                ExpenseChartCard(
                  title: 'Expenses by Payment Method',
                  icon: Icons.credit_card,
                  totals: paymentTotals,
                  selectedMonth: _selectedMonth,
                  formatCurrency: _formatCurrency,
                ),
                ExpenseChartCard(
                  title: 'Expenses by Category',
                  icon: Icons.category_outlined,
                  totals: categoryTotals,
                  selectedMonth: _selectedMonth,
                  formatCurrency: _formatCurrency,
                ),
              ];
              if (constraints.maxWidth < 600) {
                return Column(children: [for (final chart in charts) chart]);
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
