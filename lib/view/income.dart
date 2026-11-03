import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Income extends StatefulWidget {
  static const routeName = "income_page";

  const Income({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncomeState();
  }
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Income", style: TextStyle(fontSize: 24, fontWeight: .bold)),
          SizedBox(height: 16),
          for (int i = 0; i < 3; i++) ...[
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.monetization_on, color: Colors.teal),
                    title: Text("${i + 1} Payment"),
                    subtitle: Text("Job Company"),
                    trailing: Row(
                      mainAxisSize: .min,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete_outline_outlined, color: Colors.red,)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Text("01/11/2026"),
                      SizedBox(width: 16),
                      Text(
                        "+ R\$ 660,00",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: .bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
