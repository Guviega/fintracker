import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() {
    return DashboardState();
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(
                Icons.account_balance,
                color: Colors.green,
                size: 36,
              ),
              title: const Text(
                'Total Earning',
                style: TextStyle(fontSize: 14),
              ),
              subtitle: const Text(
                '+ R\$ 1.669,70',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              trailing: const Text(
                'PROFIT',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Total Income',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(
                          Icons.arrow_upward,
                          color: Colors.teal,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 12),
                          Text(
                            '+ R\$ 5.120,50',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Total Expenses',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 12),
                          Text(
                            '- R\$ 3.450,80',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                  elevation: 2,
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
                        trailing: const Icon(Icons.pie_chart_outline),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 12),
                          SizedBox(height: 120), //TODO: Payment Method chart
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
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
                      Row(
                        children: const [
                          SizedBox(width: 12),
                          SizedBox(height: 120), //TODO: Category chart
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Income / Week',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(
                          Icons.circle,
                          color: Colors.teal,
                          size: 12,
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 12),
                          SizedBox(
                            height: 100,
                          ), // TODO: Weekly Income Evolution Chart
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: const Text(
                          'Expenses / Week',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        ),
                        trailing: const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 12,
                        ),
                      ),
                      Row(
                        children: const [
                          SizedBox(width: 12),
                          SizedBox(
                            height: 100,
                          ), //TODO: Weekly Expenses Evolution Chart
                        ],
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
