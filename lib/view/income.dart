import 'package:flutter/cupertino.dart';

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
    return Column(children: [Text("Income")]);
  }
}
