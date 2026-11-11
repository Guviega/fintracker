import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  static const routeName = "expenses_page";

  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Expenses", style: TextStyle(fontSize: 24, fontWeight: .bold)),
          SizedBox(height: 16),
          for (int i = 0; i < 4; i++) ...[
            Card(
              elevation: 1,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.directions_car, color: Colors.red),
                    title: Text("Bills"),
                    subtitle: Text("Transport - Credit Card"),
                    trailing: Row(
                      mainAxisSize: .min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Text("01/11/2026"),
                      SizedBox(width: 16),
                      Text("- R\$129,90", style: TextStyle(fontSize: 18, fontWeight: .bold, color: Colors.red),)
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
