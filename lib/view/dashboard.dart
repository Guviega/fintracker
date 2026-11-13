import 'package:fintracker/imdb.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  bool isOnProfit() {
    return Imdb.getTotalResult() >= 0;
  }

  String _formatCurrency(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'R\$ $whole,${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                "+ ${_formatCurrency(Imdb.getTotalResult())}",
                style: TextStyle(
                  color: isOnProfit() ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              trailing: Text(
                Imdb.getTotalResult() == 0
                    ? ''
                    : isOnProfit()
                    ? 'PROFIT'
                    : 'LOSS',
                style: TextStyle(
                  fontSize: 14,
                  color: isOnProfit() ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
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
                            '+ ${_formatCurrency(Imdb.getTotalIncome())}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
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
              Expanded(
                child: Card(
                  elevation: 1,
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
                            "- ${_formatCurrency(Imdb.getTotalExpenses())}",
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
            ],
          ),
          SizedBox(width: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(Icons.credit_card),
                      ),
                      SizedBox(
                        height: 160,
                        child: Center(
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 50,
                                    title: 'Credit Card',
                                    titleStyle: TextStyle(fontWeight: .bold),
                                    showTitle: true,
                                    radius: 25,
                                    color: Colors.red,
                                  ),
                                  PieChartSectionData(
                                    value: 20,
                                    title: "PIX",
                                    titleStyle: TextStyle(fontWeight: .bold),
                                    showTitle: true,
                                    radius: 25,
                                    color: Colors.lightGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 1,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(Icons.category_outlined),
                      ),
                      SizedBox(
                        height: 160,
                        child: Center(
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  for (int i = 0; i < 8; i++)
                                    PieChartSectionData(
                                      value: 20,
                                      title: 'Transport',
                                      titleStyle: TextStyle(fontWeight: .bold),
                                      showTitle: true,
                                      radius: 25,
                                      color: Colors.red,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
