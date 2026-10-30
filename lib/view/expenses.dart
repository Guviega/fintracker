import 'package:flutter/cupertino.dart';

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
    return Column(children: [Text("Expenses")]);
  }
}
