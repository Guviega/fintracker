import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class IncomeForm extends StatefulWidget {
  static const routeName = "income_form";

  IncomeForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IncomeFormState();
  }
}

class _IncomeFormState extends State<IncomeForm> {
  Color detailColor = Colors.green;

  double labelSize = 12, inputTextSize = 16;

  int selectedCategory = -1;

  final maskFormatterDate = MaskTextInputFormatter(
    mask: "##/##/####",
    type: .eager,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Register Income")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: detailColor,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.arrow_upward, color: detailColor),
                      title: Text("Value"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefix: Text(
                            "+ R\$ ",
                            style: TextStyle(
                              fontSize: inputTextSize * 2,
                              fontWeight: .bold,
                              color: detailColor,
                            ),
                          ),
                          filled: true,
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: inputTextSize * 2,
                          fontWeight: .bold,
                          color: detailColor,
                        ),
                        keyboardType: .number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.description, color: detailColor),
                      title: Text("Description"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        style: TextStyle(fontSize: inputTextSize),
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_balance, color: detailColor),
                      title: Text("Source"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        style: TextStyle(fontSize: inputTextSize),
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_month, color: detailColor),
                      title: Text("Date"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                        ),
                        keyboardType: .number,
                        inputFormatters: [maskFormatterDate],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
