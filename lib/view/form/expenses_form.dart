import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ExpensesForm extends StatefulWidget {
  static const routeName = "expenses_form";

  const ExpensesForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesFormState();
  }
}

class _ExpensesFormState extends State<ExpensesForm> {
  Color detailColor = Colors.red;

  double labelSize = 12, inputTextSize = 16;

  int selectedCategory = -1;
  int selectedPaymentMethod = -1;

  final maskFormatterDate = MaskTextInputFormatter(
    mask: "##/##/####",
    type: .eager,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 2, title: Text("Register Expense")),
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
                      leading: Icon(Icons.arrow_downward, color: detailColor),
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
                      leading: Icon(Icons.category, color: detailColor),
                      title: Text("Category"),
                    ),
                    Wrap(
                      children: [
                        for (int i = 0; i < 4; i++) ...[
                          ChoiceChip(
                            label: Text("Category $i"),
                            selected: selectedCategory == i,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCategory = i;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            selectedColor: detailColor,
                            backgroundColor: Colors.grey.shade200,
                            elevation: 2,
                          ),
                          SizedBox(width: 8),
                        ],
                      ],
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
                      leading: Icon(Icons.credit_card, color: detailColor),
                      title: Text("Payment Method"),
                    ),
                    Wrap(
                      children: [
                        for (int i = 0; i < 4; i++) ...[
                          ChoiceChip(
                            label: Text("Method $i"),
                            selected: selectedPaymentMethod == i,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedPaymentMethod = i;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            selectedColor: detailColor,
                            backgroundColor: Colors.grey.shade200,
                            elevation: 2,
                          ),
                          SizedBox(width: 8),
                        ],
                      ],
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
